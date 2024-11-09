import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model.dart/classification.dart';

Future<classification?> fetchAudioClassification(String youtubeUrl) async {
  print("Fetching audio data...");

  try {
    // Sending the GET request to fetch audio data
    final response = await http.get(
      Uri.parse('http://localhost:3000/get-audio?url=${Uri.encodeComponent(youtubeUrl)}'),
    );

    print("Response Body: ${response.body}");

    // Check if the request was successful
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if the necessary keys are in the response body
      if (data.containsKey('audioUrl') && data.containsKey('title') && data.containsKey('writer')) {
        final audioUrl = data['audioUrl'];
        final title = data['title'];
        final writer = data['writer'];

        // Check if audioUrl is not null and proceed to return the classification
        if (audioUrl != null && title != null && writer != null) {
          return classification(
            musicTitle: title,  // Using the title from the response
            musicWriter: writer,  // Using the writer from the response
            audioUrl: audioUrl,  // Using the audioUrl from the response
          );
        } else {
          print('Error: Missing data in response (audioUrl, title, or writer is null)');
        }
      } else {
        print('Error: Missing keys in response: audioUrl, title, or writer');
      }
    } else {
      print('Failed to fetch audio URL: ${response.reasonPhrase}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print("Error fetching audio data: $e");
  }
  return null;
}
