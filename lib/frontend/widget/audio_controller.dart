import 'package:just_audio/just_audio.dart';

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