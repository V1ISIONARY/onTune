import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'model/classification.dart';
import 'model/randomized.dart';

class OnTuneRepository {
  final String apiURL = 'https://on-tune-api.vercel.app';
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Future<List<Randomized>> fetchExplore() async {
    try {
      final response = await http.get(Uri.parse('$apiURL/playlist'));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');  // Log the response
        final data = json.decode(response.body);

        if (data['songInfo'] != null && data['songInfo'] is List) {
          final songList = data['songInfo'] as List;
          return songList.map((song) => Randomized.fromJson(song)).toList();
        } else {
          throw Exception("Unexpected response format: 'songInfo' is null or not a list");
        }
      } else {
        throw Exception("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");  // Log the error
      throw Exception("Error fetching explore data: $e");
    }
  }
  
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
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Extract fields with null safety
      final String? audioUrl = data['audioUrl'] as String?;
      final String title = data['title'] as String? ?? 'Unknown Title';
      final String writer = data['writer'] as String? ?? 'Unknown Writer';
      final String? lyrics = data['lyrics'] as String?;

      if (audioUrl != null) {
        // Set the audio source
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
        print('Audio URL: $audioUrl');
        
        // Return classification object
        return Classification(
          musicTitle: title,
          musicWriter: writer,
          audioUrl: audioUrl,
          lyrics: lyrics ?? 'Lyrics not available', // Default value if lyrics is null
        );
      } else {
        print('Error: audioUrl is null');
        return null;
      }
    } else {
      print('Failed to fetch audio URL: ${response.statusCode} - ${response.reasonPhrase}');
      print('Request URL: ${response.request?.url}');
      return null;
    }
  } catch (e) {
    print("Error during initialization: $e");
    return null;
  }
}

}