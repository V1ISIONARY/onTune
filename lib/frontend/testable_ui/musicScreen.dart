// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:just_audio/just_audio.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MusicScreen extends StatefulWidget {
//   @override
//   _MusicScreenState createState() => _MusicScreenState();
// }

// class _MusicScreenState extends State<MusicScreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final String apiURL = 'http://127.0.0.1:5000';  // Replace with your actual API URL

//   // Example track URI (can replace with your track URI)
//   final String spotifyTrackUrl = 'https://open.spotify.com/track/3OpGUlDmRUXh0NkIYWoIlD';

//   Future<Classification?> initializeAudio(String trackUri, BuildContext context) async {
//     try {
//       print('Track URI: $trackUri');
//       // Send a POST request to the API to fetch audio details
//       final response = await http.post(
//         Uri.parse('$apiURL/play?track_uri=$trackUri'),
//         headers: {'Content-Type': 'application/json'}, // Assuming the server expects JSON
//       );

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = jsonDecode(response.body);

//         final String? audioUrl = data['audioUrl'] as String?;
//         final String title = data['title'] as String? ?? 'Unknown Title';
//         final String writer = data['writer'] as String? ?? 'Unknown Writer';
//         final String? lyrics = data['lyrics'] as String?;

//         if (audioUrl != null && audioUrl.isNotEmpty) {
//           // Ensure the audio URL is valid before setting it
//           try {
//             await _audioPlayer.setUrl(audioUrl);
//             print('Audio URL: $audioUrl');
            
//             // Show an AlertDialog with music details
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text('Now Playing'),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('Title: $title'),
//                       Text('Writer: $writer'),
//                       if (lyrics != null) Text('Lyrics: $lyrics'),
//                       ElevatedButton(
//                         onPressed: () {
//                           _audioPlayer.play();
//                           Navigator.of(context).pop();
//                         },
//                         child: Text('Play Audio'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );

//             return Classification(
//               musicTitle: title,
//               musicWriter: writer,
//               audioUrl: audioUrl,
//               lyrics: lyrics ?? 'Lyrics not available',
//             );
//           } catch (e) {
//             print("Error setting audio URL: $e");
//           }
//         } else {
//           print('Error: audioUrl is null or empty');
//           return null;
//         }
//       } else {
//         print('Failed to fetch audio URL: ${response.statusCode} - ${response.reasonPhrase}');
//         return null;
//       }
//     } catch (e) {
//       print("Error during initialization: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Music Player'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Container mimicking the Spotify embedded player
//           Container(
//             width: 300,
//             height: 380,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               image: DecorationImage(
//                 image: NetworkImage('https://i.scdn.co/image/ab67616d0000b2733f5b4b3dff19bc3b158dc6ab'), // Spotify album image
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final Uri spotifyUri = Uri.parse(spotifyTrackUrl);
//                   if (await canLaunchUrl(spotifyUri)) {
//                     await launchUrl(spotifyUri);
//                   } else {
//                     throw 'Could not launch $spotifyTrackUrl';
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black.withOpacity(0.6), // Semi-transparent black background
//                   shape: CircleBorder(),
//                   padding: EdgeInsets.all(16),
//                 ),
//                 child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Example Spotify URI, you can replace this with any URI
//               initializeAudio("https://open.spotify.com/track/3OpGUlDmRUXh0NkIYWoIlD", context);
//             },
//             child: Text('Fetch and Play Music'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Classification {
//   final String musicTitle;
//   final String musicWriter;
//   final String audioUrl;
//   final String lyrics;

//   Classification({
//     required this.musicTitle,
//     required this.musicWriter,
//     required this.audioUrl,
//     required this.lyrics,
//   });
// }
