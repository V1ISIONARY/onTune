import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'model/classification.dart';
import 'model/randomized.dart';

class OnTuneRepository {
  final String apiURL = 'http://192.168.0.154:3000';
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Future<List<Randomized>> fetchExplore() async {
    
    final String fileContent = await rootBundle.loadString('lib/resources/links/randomized.txt');

    // Split the file content into lines (each line contains a URL)
    final List<String> urlList = fileContent.split('\n').map((url) => url.trim()).toList();

    // Encode the URLs
    String encodedUrls = urlList.map((url) => Uri.encodeComponent(url)).join('&urls[]=');

    // Send the GET request with the dynamic URLs
    final response = await http.get(Uri.parse('$apiURL/fetch-randomized-playlist?urls[]=$encodedUrls'));


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Check if 'songInfo' is available and is a list
      if (data['songInfo'] != null && data['songInfo'] is List) {
        final songList = data['songInfo'] as List;
        return songList.map((song) => Randomized.fromJson(song)).toList();
      } else {
        throw Exception("Unexpected response format: 'songInfo' is null or not a list");
      }
    } else {
      throw Exception("Failed to fetch data");
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