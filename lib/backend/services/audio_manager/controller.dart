import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:ontune/backend/services/audio_manager/model.dart/classification.dart';
import 'dart:async';

class AudioController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isMuted = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  Duration get duration => _duration;
  Duration get position => _position;

  AudioController() {
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

  Future<classification?> initializeAudio(String youtubeUrl) async {
    try {
      // Audio URL fetching logic (update with your actual implementation)
      final response = await http.get(
        Uri.parse('http://localhost:3000/get-audio?url=${Uri.encodeComponent(youtubeUrl)}')
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final audioUrl = data['audioUrl'];
        final title = data['title'];
        final writer = data['writer'];

        if (audioUrl != null) {
          await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
          print(audioUrl);
          return classification(
            musicTitle: title,
            musicWriter: writer,
            audioUrl: audioUrl,
          );
        } else {
          print('Error: audioUrl is null');
        }
      } else {
        print('Failed to fetch audio URL: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during audio initialization: $e');
    }
    return null; // Return null if failed
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
