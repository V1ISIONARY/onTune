import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ontune/backend/services/spotify.dart';

class AudioController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isMuted = false;
  String? _previewUrl;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Getters for external use
  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  Duration get duration => _duration;
  Duration get position => _position;
  String? get previewUrl => _previewUrl;

  AudioController();

  Future<void> fetchPreview(String trackId) async {
    try {
      String? url = await SpotifyService().fetchPreviewUrl(trackId);
      if (url != null) {
        _previewUrl = url;
        await _audioPlayer.setUrl(_previewUrl!);
      } else {
        print("No preview available for track: $trackId");
      }
    } catch (e) {
      print("Error fetching preview: $e");
    }
  }

  void initialize() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
    });
    _audioPlayer.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
    });
    _audioPlayer.positionStream.listen((p) {
      _position = p;
    });
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void stop() {
    _audioPlayer.stop();
    _audioPlayer.seek(Duration.zero);
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _audioPlayer.setVolume(_isMuted ? 0 : 1);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String trackId;
  const AudioPlayerWidget({Key? key, required this.trackId}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioController _audioController;

  @override
  void initState() {
    super.initState();
    _audioController = AudioController();
    _audioController.initialize();
    _audioController.fetchPreview(widget.trackId);

    _audioController.audioPlayer.positionStream.listen((_) {
      setState(() {});
    });
    _audioController.audioPlayer.playerStateStream.listen((_) {
      setState(() {});
    });
    _audioController.audioPlayer.durationStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _audioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate current duration and position in seconds
    final durationSeconds = _audioController.duration.inSeconds.toDouble();
    final positionSeconds = _audioController.position.inSeconds.toDouble();

    return Scaffold(
      backgroundColor: Colors.black, // Dark background for audio player
      appBar: AppBar(
        title: Text('Audio Player'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status message for preview availability
            _audioController.previewUrl == null
                ? Text(
                    "Loading preview...",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                : Text(
                    "Preview ready",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
            SizedBox(height: 20),
            // Row with playback control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play/Pause Button
                IconButton(
                  icon: Icon(
                    _audioController.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _audioController.togglePlayPause();
                    });
                  },
                ),
                // Stop Button
                IconButton(
                  icon: Icon(
                    Icons.stop,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _audioController.stop();
                    });
                  },
                ),
                // Mute/Unmute Button
                IconButton(
                  icon: Icon(
                    _audioController.isMuted
                        ? Icons.volume_off
                        : Icons.volume_up,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _audioController.toggleMute();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display position / duration text
            Text(
              "${_audioController.formatDuration(_audioController.position)} / ${_audioController.formatDuration(_audioController.duration)}",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            // Progress Slider
            Slider(
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              min: 0,
              max: durationSeconds > 0 ? durationSeconds : 1,
              value: positionSeconds.clamp(0, durationSeconds > 0 ? durationSeconds : 1),
              onChanged: (value) {
                setState(() {
                  _audioController.audioPlayer.seek(Duration(seconds: value.toInt()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}