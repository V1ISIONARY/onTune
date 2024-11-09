import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ontune/resources/schema.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;
import '../resources/widget/fade.dart';

class Player extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onClose;
  final String youtubeUrl;
  final String musicTitle;
  final String writer;


  const Player({
    Key? key,
    required this.musicTitle,
    required this.writer,
    required this.youtubeUrl,
    required this.backgroundColor,
    required this.textColor,
    required this.onClose,
  }) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();
  bool _isPlaying = false;
  bool _isMuted = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  late String musicTitle;
  late String writer;

  @override
  void initState() {
    super.initState();
    _initializeAudio();

    _audioPlayer.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });

    _audioPlayer.durationStream.listen((d) {
      setState(() => _duration = d ?? Duration.zero);
    });

    _audioPlayer.positionStream.listen((p) {
      setState(() => _position = p);
    });
  }

Future<void> _initializeAudio() async {
  
    print("Initializing audio..."); // Add this print statement
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/get-audio?url=${Uri.encodeComponent(widget.youtubeUrl)}')
      );

      print("Response Body: ${response.body}"); // Log the response body

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          final audioUrl = data['audioUrl'];

          if (audioUrl != null) {
            await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
            setState(() {});  // Trigger UI update
          } else {
            print('Error: audioUrl is null');
          }
        } catch (e) {
          print('Error parsing JSON: $e');
          print('Response Body: ${response.body}');  // Log the raw response body
        }
      } else {
        print('Failed to fetch audio URL: ${response.reasonPhrase}');
        print('Response body: ${response.body}');  // Log the response body to see the error
      }
    } catch (e) {
      print("Error during audio initialization: $e");
    }
}

  @override
  void dispose() {
    _audioPlayer.dispose();
    _yt.close();
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
                    SizedBox(height: 130),
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
                                    'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2J2bDRzZmNraDJ4cHA3NHlmY24xd3JzcWJjNWdmOWduemJyYmxnZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/dYdEHJKB52aFB7k3bE/giphy.webp',
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
                          // Transform.translate(
                          //   offset: Offset(0, -10.0),
                          //   child: Container(
                          //     height: 150,
                          //     width: double.infinity,
                          //     margin: EdgeInsets.symmetric(horizontal: 50),
                          //     decoration: BoxDecoration(
                          //       color: widgetPricolor, // Assuming widgetPricolor is defined properly
                          //       borderRadius: BorderRadius.only(
                          //         bottomRight: Radius.circular(10),
                          //         bottomLeft: Radius.circular(10),
                          //       ),
                          //     ),
                          //     child: Container(
                          //       margin: EdgeInsets.all(10),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Row(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Padding(
                          //                 padding: EdgeInsets.only(top: 2.5, right: 5),
                          //                 child: Icon(
                          //                   Icons.lyrics_sharp,
                          //                   color: Colors.white,
                          //                   size: 15.0, // Optional size adjustment
                          //                 ),
                          //               ),
                          //               Text(
                          //                 'Lyrics',
                          //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                          //               ),
                          //             ]
                          //           )
                          //         ],
                          //       )
                          //     )
                          //   ),
                          // ),
                        ],
                      )
                    ),
                  ]
                ),
                Positioned(
                  bottom: 90,
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
                                        Text(
                                          widget.musicTitle ?? 'Loading...',
                                          style: TextStyle(fontSize: 15, color: widget.textColor),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          widget.writer ?? 'Billie Ellish',
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
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                    _audioPlayer.seek(position);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDuration(_position), style: TextStyle(fontSize: 11, color: widget.textColor)),
                                  Text(_formatDuration(_duration), style: TextStyle(fontSize: 11, color: widget.textColor)),
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
                                      onPressed: _togglePlayPause,
                                    ),
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
                        'Videos from ${widget.writer}',
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
          SizedBox(height: 200)
        ]
      ),
    );
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _stop() {
    _audioPlayer.stop();
    _audioPlayer.seek(Duration.zero);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _audioPlayer.setVolume(_isMuted ? 0 : 1);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  
}