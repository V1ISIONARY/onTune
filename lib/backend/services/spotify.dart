import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String clientId = '8397c415a12d4bec89fb7264e2e8b1e3';
  final String clientSecret = 'b733e81859474fe7ab8fc087642c2c56';
  
  Future<String?> fetchPreviewUrl(String trackId) async {
    final authResponse = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode("$clientId:$clientSecret"))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (authResponse.statusCode != 200) {
      throw Exception("Failed to authenticate with Spotify");
    }

    final authData = jsonDecode(authResponse.body);
    final accessToken = authData['access_token'];

    // Fetch the track data
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$trackId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['preview_url'] != null) {
        return data['preview_url']; // Return preview URL if available
      } else {
        print("No preview available for track: $trackId");
        return null;
      }
    } else {
      throw Exception("Failed to fetch track data");
    }
  }
}
