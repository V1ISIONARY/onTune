import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'audio_manager/model.dart/Classification.dart';

class OnTuneRepository {
  final String apiURL = 'http://192.168.0.154:3000';
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Future<Classification?> initializeAudio(String youtubeUrl) async {
    try {
      // Convert YouTube Music URL to regular YouTube URL
      String regularYoutubeUrl = youtubeUrl.replaceFirst('music.youtube.com', 'www.youtube.com');
      
      final response = await http.get(
        Uri.parse('$apiURL/get-audio?url=${Uri.encodeComponent(regularYoutubeUrl)}')
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final audioUrl = data['audioUrl'];
        final title = data['title'];
        final writer = data['writer'];
        final lyrics = data['lyrics'];

        if (audioUrl != null) {
          await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
          print('Audio URL: $audioUrl');
          return Classification(
            musicTitle: title,
            musicWriter: writer,
            audioUrl: audioUrl,
            lyrics: lyrics,
          );
        } else {
          print('Error: audioUrl is null');
        }
      } else {
        print('Failed to fetch audio URL: ${response.statusCode} - ${response.reasonPhrase}');
        print('Request URL: ${response.request?.url}');
      }
    } catch (e) {
      print("Error during initialization: $e");
    }

    return null;
  }
}