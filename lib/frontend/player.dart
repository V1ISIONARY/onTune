// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ontune/resources/schema.dart';

import '../backend/services/audio_manager/controller.dart';
import '../backend/services/audio_manager/model.dart/classification.dart';
import '../resources/widget/fade.dart';

class Player extends StatefulWidget {
  final Color textColor;
  final String youtubeUrl;
  final VoidCallback onClose;
  final Color backgroundColor;

  const Player({
    Key? key, 
    required this.youtubeUrl,
    required this.backgroundColor,
    required this.textColor,
    required this.onClose,
  }) : super(key: key);
  
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {
  
  final AudioController _audioController = AudioController();
  late AnimationController _animationController;
  late Animation<Offset> _scrollAnimation;
  String musicTitle = '';
  String writer = '';
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _opacity = 0.0;  
  
  @override
  void initState() {
    super.initState();
    _initializeAudio();

    // Listening to the player state changes
    _audioController.audioPlayer.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });

    // Listening to the audio duration
    _audioController.audioPlayer.durationStream.listen((d) {
      setState(() => _duration = d ?? Duration.zero);
    });

    // Listening to the audio position
    _audioController.audioPlayer.positionStream.listen((p) {
      setState(() => _position = p);
    });

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Duration of one loop
    )..repeat(); // Repeating the animation indefinitely

    // Create Tween for sliding the text
    _scrollAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),  // Starting position (off screen to the right)
      end: Offset(-1.0, 0.0),  // Ending position (off screen to the left)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,  // Smooth continuous movement
    ));

    _startFadeOut();

  }

  Future<void> _initializeAudio() async {
    final classification? audioData = await _audioController.initializeAudio(widget.youtubeUrl);

    if (audioData != null) {
      setState(() {
        musicTitle = audioData.musicTitle;
        writer = audioData.musicWriter;
      });
    } else {
      print("Failed to initialize audio.");
    }

    // Updating playback status and duration
    setState(() {
      _isPlaying = _audioController.isPlaying;
      _duration = _audioController.duration;
      _position = _audioController.position;
    });
  }

  void _startFadeOut() {
    // Delay before starting the fade-out
    Future.delayed(Duration(seconds: 3), () { // Adjust timing as needed
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (_opacity >= 1.0) {
          timer.cancel();
        } else {
          setState(() {
            _opacity += 0.1;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _audioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary_color,
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height, // Full screen height
            child: Stack(
              children: [
                Positioned.fill(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity, // Set desired width
                        height: double.infinity, // Set desired height
                        child: Image.network(
                          'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2J2bDRzZmNraDJ4cHA3NHlmY24xd3JzcWJjNWdmOWduemJyYmxnZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/dYdEHJKB52aFB7k3bE/giphy.webp',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey); // Default if image fails
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: Colors.white.withOpacity(0.2), // Adjust opacity for frosted effect
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                CustomPaint(
                  painter: WhiteBackgroundPainter(),
                  child: Container(),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  ),
                  title: const Text(
                    'Recommended for you',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  centerTitle: true,
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          // Additional functionality here
                        },
                        icon: const Icon(Icons.more_horiz, color: Colors.white),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 110),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 450,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Match container's border radius
                              child: Stack(
                                fit: StackFit.expand, // Ensure the image and text fill the available space
                                children: [
                                  Image.network(
                                    'https://ph.pinterest.com/pin/837036280740711560/',
                                    fit: BoxFit.cover, // Ensures the image covers the area
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey, // Default if image fails to load
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(  // You can change the position of the text here
                                    bottom: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: Icon(Icons.lyrics_outlined),  // Correctly pass the icon to the icon property
                                      iconSize: 20,  // Set the size of the icon
                                      color: Colors.white,  // Set the icon color
                                      onPressed: () {
                                        // Your onPressed function here
                                      },
                                    )
                                  ),
                                ],
                              ),
                            )
                          ),
                        ],
                      )
                    ),
                  ]
                ),
                Positioned(
                  bottom: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 60,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,  // Fixed width of the container
                                          height: 25,  // Fixed height of the container
                                          child: ClipRect(  // Ensure the SlideTransition does not overflow
                                            child: musicTitle.length < 30  // If the music title is shorter than 20 characters
                                                ? // No SlideTransition if the title is short
                                                SingleChildScrollView(  // Text will not scroll horizontally if the title is short
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      musicTitle.isNotEmpty ? musicTitle : 'Title',
                                                      style: TextStyle(fontSize: 15, color: widget.textColor),
                                                      textAlign: TextAlign.start,  // Align text to the start (left side)
                                                    ),
                                                  )
                                                : // SlideTransition only when the title is long enough
                                                SlideTransition(
                                                    position: _scrollAnimation,  // Apply SlideTransition only for longer titles
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,  // Allow horizontal scrolling
                                                      child: Text(
                                                        musicTitle.isNotEmpty ? musicTitle : 'Title',
                                                        style: TextStyle(fontSize: 15, color: widget.textColor),
                                                        textAlign: TextAlign.start,  // Align text to the start (left side)
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Text(
                                          limitText(writer.isNotEmpty ? writer : 'Comperser', 20), // Handle null or empty check
                                          style: TextStyle(fontSize: 10, color: secondary_color),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: Container(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Center(
                                            child: Icon(
                                              size: 20,
                                              color: Colors.white,
                                              Icons.headset_rounded
                                            )
                                          ),
                                          SizedBox(width: 10),
                                          Center(
                                            child: Icon(
                                              size: 20,
                                              color: Colors.white,
                                              Icons.heart_broken
                                            )
                                          )
                                        ]
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0), // Removes the thumb
                                  overlayShape: RoundSliderOverlayShape(overlayRadius: 0),  // Removes the overlay on thumb
                                ),
                                child: Slider(
                                  value: _position.inSeconds.toDouble(),
                                  min: 0,
                                  max: _duration.inSeconds.toDouble(),
                                  activeColor: Colors.white38,      // Set the color of the filled (progressed) part
                                  inactiveColor: Colors.white24,    // Set the color of the unfilled (remaining) part
                                  onChanged: (value) {
                                    final position = Duration(seconds: value.toInt());
                                    _audioController.audioPlayer.seek(position);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${_audioController.formatDuration(_audioController.position)}", style: TextStyle(fontSize: 11, color: widget.textColor)),
                                  Text("${_audioController.formatDuration(_audioController.duration)}", style: TextStyle(fontSize: 11, color: widget.textColor)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.stop, color: widget.textColor),
                                //   onPressed: _stop,
                                // ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.crop_rounded,
                                      color: widget.textColor, // Icon color from the widget properties
                                    ),
                                    onPressed: (){},
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(
                                      size: 30,
                                      Icons.skip_previous,
                                      color: widget.textColor, // Icon color from the widget properties
                                    ),
                                    onPressed: (){},
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // Directly use BoxShape.circle for circular shape
                                      color: widget.textColor, // You can customize background color here
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        size: 30,
                                        _isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.black, // Icon color from the widget properties
                                      ),
                                      onPressed: () {
                                        // Toggle play/pause on button press
                                        _audioController.togglePlayPause();
                                      },
                                    )
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(
                                      size: 30,
                                      Icons.skip_next,
                                      color: widget.textColor, // Icon color from the widget properties
                                    ),
                                    onPressed: (){},
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.loop_outlined,
                                      color: widget.textColor, // Icon color from the widget properties
                                    ),
                                    onPressed: (){},
                                  ),
                                ),
                                // IconButton(
                                //   icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up, color: widget.textColor),
                                //   onPressed: _toggleMute,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                    ]
                  )
                ),
                Positioned(
                  bottom: -50,  // Move the container 50 units down from the bottom of its parent
                  left: 20,  // 20 units from the left
                  right: 20,  // 20 units from the right
                  child: Container(
                    width: 500,  // You can adjust this value or use double.infinity if needed
                    height: 100,  // Height of the container
                    decoration: BoxDecoration(
                      color: widgetPricolor,  // Set the background color
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        'Videos from ${writer}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: widgetPricolor,  // Set the background color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 250,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: widgetPricolor, // Set the background color
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0, // Position this container at the bottom of the Stack
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100)
        ]
      ),
    );
  }

}

String limitText(String text, int maxLength) {
  return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
}