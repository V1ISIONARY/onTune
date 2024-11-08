import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ontune/resources/schema.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

class Player extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onClose;
  final String youtubeUrl;

  const Player({
    Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.onClose,
    required this.youtubeUrl,
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
  String? _thumbnailUrl;
  String? _videoTitle;

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
          print('Parsed JSON: $data');

          final audioUrl = data['audioUrl'];

          if (audioUrl != null) {
            print('Audio URL: $audioUrl');  // Print the audio URL for debugging
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
      backgroundColor: widget.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(600),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2J2bDRzZmNraDJ4cHA3NHlmY24xd3JzcWJjNWdmOWduemJyYmxnZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/dYdEHJKB52aFB7k3bE/giphy.webp',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey); // Default if image fails
                },
              ),
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
                IconButton(
                  onPressed: () {
                    // Additional functionality here
                  },
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     _videoTitle ?? 'Loading...',
          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.textColor),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
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
                        _videoTitle ?? 'Loading...',
                        style: TextStyle(fontSize: 15, color: widget.textColor),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _videoTitle ?? 'Billie Ellish',
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
          Slider(
            value: _position.inSeconds.toDouble(),
            min: 0,
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              final position = Duration(seconds: value.toInt());
              _audioPlayer.seek(position);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position), style: TextStyle(fontSize: 13,color: widget.textColor)),
                Text(_formatDuration(_duration), style: TextStyle(fontSize: 13,color: widget.textColor)),
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
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Directly use BoxShape.circle for circular shape
                    color: primary_textColor, // You can customize background color here
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: widget.textColor, // Icon color from the widget properties
                    ),
                    onPressed: (){},
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Directly use BoxShape.circle for circular shape
                    color: Colors.black, // You can customize background color here
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: widget.textColor, // Icon color from the widget properties
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Directly use BoxShape.circle for circular shape
                    color: primary_textColor, // You can customize background color here
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: widget.textColor, // Icon color from the widget properties
                    ),
                    onPressed: (){},
                  ),
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
