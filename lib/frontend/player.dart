// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontune/resources/schema.dart';
import '../backend/bloc/on_tune_bloc.dart';
import '../resources/pockets/audio_controller.dart';
import '../resources/pockets/designs/fade.dart';

class Player extends StatefulWidget {
  final Color textColor;
  final VoidCallback onClose;
  final Color backgroundColor;

  final String youtubeUrl;
  final String thumbnail;

  const Player({
    Key? key,
    required this.youtubeUrl,
    required this.thumbnail,
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
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double frontContainerHeight = 300;
  bool isLyricsVisible = false;
   bool _isPlaying = false;
  String musicTitle = '';
  double _opacity = 0.0;
  String writer = '';
  String lyrics = '';
 
  void toggleHeight() {
    setState(() {
      frontContainerHeight = frontContainerHeight == 300 ? 245 : 300;
    });
  }

  @override
  void initState() {
    super.initState();

    _audioController.audioPlayer.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
      print("Player state changed: ${state.playing ? 'playing' : 'paused'}");
    });

    _audioController.audioPlayer.durationStream.listen((d) {
      setState(() => _duration = d ?? Duration.zero);
    });

    _audioController.audioPlayer.positionStream.listen((p) {
      setState(() => _position = p);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();

    _scrollAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _startFadeOut();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<OnTuneBloc>().add(FindAudio(widget.youtubeUrl));
  }

  void _startFadeOut() {
    Future.delayed(Duration(seconds: 3), () {
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary_color,
      body: BlocConsumer<OnTuneBloc, OnTuneState>(
        listener: (context, state) {
          if (state is FetchedAudio) {

            _audioController.audioPlayer.setUrl(state.audioUrl).then((_) {
              print("Audio source set, attempting to play");
              _audioController.audioPlayer.play().then((_) {
                print("Play command issued");
              }).catchError((error) {
                print("Error playing audio: $error");
              });
            }).catchError((error) {
              print("Error setting audio source: $error");
            });

          }
        },
        builder: (context, state) {
          if (state is LoadingTune) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchedAudio) {
            musicTitle = state.musicTitle;
            writer = state.musicWriter;
            lyrics = state.lyrics;
            return Scaffold(
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
                          painter: WhiteBackgroundPainter(height: 0.6, begin: Alignment.topLeft, end: Alignment.bottomRight),
                          child: Container(),
                        ),
                        AppBar(
                          backgroundColor: Colors.transparent,
                          leading: IconButton(
                            onPressed: (){
                              context.read<OnTuneBloc>().add(LoadTune());
                              widget.onClose();
                            },
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
                        Container(
                          child: Column(
                            children: [
                              SizedBox(height: 110),
                              InkWell(
                                onTap: (){
                                  toggleHeight();
                                },
                                child: Container(
                                  height: 300, // Fixed height for the container
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)
                                          ), // Match container's border radius
                                          child: Container(
                                            color: Colors.black.withOpacity(0.7),
                                            padding: EdgeInsets.all(10),
                                            child: SingleChildScrollView(
                                              child: Text(
                                                limitText(lyrics.isNotEmpty ? lyrics : 'No available lyrics', 20),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10), // Match container's border radius
                                        child: Stack(
                                          fit: StackFit.expand, // Ensure the image and text fill the available space
                                          children: [
                                            // Front Layer: Image (Dynamic height)
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              right: 0,
                                              child: Stack(
                                                children: [
                                                  AnimatedContainer(
                                                    duration: Duration(milliseconds: 300), // Smooth height transition
                                                    height: frontContainerHeight, // Dynamic height for the front image
                                                    child: Image.network(
                                                      widget.thumbnail,
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
                                                  ),
                                                  Positioned(  // Icon button to toggle visibility of the lyrics section
                                                    bottom: 10,
                                                    right: 10,
                                                    child: IconButton(
                                                      icon: Icon(Icons.lyrics_outlined),  // Correctly pass the icon to the icon property
                                                      iconSize: 20,  // Set the size of the icon
                                                      color: Colors.white,  // Set the icon color
                                                      onPressed: toggleHeight,  // Call toggleHeight on icon press
                                                    ),
                                                  ),
                                                ]
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              )
                            ],
                          ),
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
                    width: 100,
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
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: EdgeInsets.all(20),
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: widgetPricolor,
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: widgetPricolor,
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: widgetPricolor,
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: widgetPricolor, // Set the background color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.network(
                            'https://wallpapers.com/images/hd/phil-collins-monochromatic-onstage-tzfi4v03wkyd10ak.jpg',
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
                          Positioned(
                            bottom: 0, // Position this container at the bottom of the Stack
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: widgetPricolor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              'Greatest Hits of ${writer}',
                              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                            )
                          ),
                          Positioned(
                            right: 20,
                            top: 2,
                            bottom: 2,
                            child: InkWell(
                              onTap: (){},
                              child: Text('See All',
                                style: TextStyle(color: Colors.white38, fontSize: 10.0)
                              )
                            )
                          )
                        ],
                      ),
                    )
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 140,
                      height: 190,
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                              color: widgetPricolor,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Happier Than Ever',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Billie Elish', 
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 100)
                ]
              )
            );
          } else if (state is ErrorTune) {
            return Center(
              child: Text(
                "Error: ${state.response}",
                style: TextStyle(color: widget.textColor),
              ),
            );
          }
          return const SizedBox.shrink();
        }
      )
    );
  }

}

String limitText(String text, int maxLength) {
  return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
}