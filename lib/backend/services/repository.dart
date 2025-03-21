import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:ontune/backend/services/model/artist.dart';
import 'package:ontune/backend/services/model/lyrics.dart';
import 'package:ontune/backend/services/model/songs.dart';
import 'package:ontune/backend/services/model/weather_model.dart';
import 'model/classification.dart';
import 'model/randomized.dart';

class OnTuneRepository {
  final String apiURL = 'https://on-tune-api.vercel.app';
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Future<List<Randomized>> fetchExplore() async {
    try {
      final response = await http.get(Uri.parse('$apiURL/playlist'));

      if (response.statusCode == 200) {
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

      print(youtubeUrl);

      final response = await http.get(
        Uri.parse('$apiURL/get-spotify-audio?url=$youtubeUrl') 
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
            musicTitle: title ?? 'Lyrics not available',
            musicWriter: writer ?? 'Lyrics not available',
            audioUrl: audioUrl ?? 'Lyrics not available',
            lyrics: lyrics ?? 'Lyrics not available',
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

  Future<Artist> fetchArtist(String artistName) async {
    try {
      final response = await http.get(Uri.parse('$apiURL/search?artist=$artistName'));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return Artist.fromJson(data);
        } else {
          throw Exception("Empty artist data");
        }
      } else {
        throw Exception("Failed to load artist data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching artist: $e");
      throw Exception("Error fetching artist data");
    }
  }

  Future<Lyrics> fetchLyrics(String title, String writer) async {
    try {
      final response = await http.get(Uri.parse('$apiURL/get_lyrics?title=$title&writer=$writer'));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return Lyrics.fromJson(data);
        } else {
          throw Exception("Empty artist data");
        }
      } else {
        throw Exception("Failed to load artist data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching artist: $e");
      throw Exception("Error fetching artist data");
    }
  }

  Future<WeatherModel> fetchWeather(String city) async {
    final response = await http.get(Uri.parse("$apiURL/weather?city=$city"));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<List<SongModel>> fetchSongs(String query) async {
    final response = await http.get(Uri.parse('$apiURL/search_song?query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => SongModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch songs");
    }
  }

}