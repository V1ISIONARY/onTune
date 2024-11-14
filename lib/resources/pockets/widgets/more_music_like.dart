import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/services/model/randomized.dart';
import '../../schema.dart';
import 'actions/single_music.dart';
import '../floating_music.dart';
import 'dart:math';

class MoreMusicLike extends StatelessWidget {
  final String title;
  final List<Randomized> songs;
  final VoidCallback onToggle;
  final GlobalKey<FloatingMusicState> floatingMusicKey;

  const MoreMusicLike({
    Key? key,
    required this.title,
    required this.songs,
    required this.onToggle,
    required this.floatingMusicKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Create a Map to count occurrences of each artist
    Map<String, int> artistCount = {};
    for (var song in songs) {
      artistCount[song.musicWriter] = (artistCount[song.musicWriter] ?? 0) + 1;
    }

    // Filter the list to include only artists that appear at least three times
    List<Randomized> repeatedArtists = songs.where((song) {
      return artistCount[song.musicWriter]! >= 3;
    }).toList();

    // Create a Set to track unique artist names among the repeated artists
    Set<String> seenArtists = {};

    // Filter to get unique artists from the repeated artists list
    List<Randomized> uniqueRepeatedArtists = repeatedArtists.where((song) {
      if (seenArtists.contains(song.musicWriter)) {
        return false; // Skip if the artist is already seen
      } else {
        seenArtists.add(song.musicWriter); // Add the artist name to the set
        return true;
      }
    }).toList();

    // Randomly select an artist from the unique repeated artists
    final random = Random();
    final String randomArtist = uniqueRepeatedArtists.isNotEmpty
        ? uniqueRepeatedArtists[random.nextInt(uniqueRepeatedArtists.length)].musicWriter
        : 'No artist found';

    // Filter songs by the randomly selected artist
    final filteredSongs = songs.where((song) => song.musicWriter == randomArtist).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: primary_color,
                          shape: BoxShape.circle
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            filteredSongs.isNotEmpty
                                ? filteredSongs[0].thumnail // Access the thumbnail of the first filtered song
                                : '', // Default to an empty string if no song is found
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 40,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'More Music like',
                                style: TextStyle(color: Colors.white, fontSize: 10.0)
                              ),
                              Text(
                                randomArtist,
                                style: GoogleFonts.notoSans(
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w800)
                                )
                              )
                            ],
                          )
                        )
                      )
                    ],
                  ),
                )
              ]
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = filteredSongs[index];
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 10),
                    child: single_music_action(
                      onToggle: onToggle,
                      musicTitle: song.musicTitle,
                      musicWriter: song.musicWriter,
                      audioUrl: song.audioUrl,
                      thumbnail: song.thumnail,
                      floatingMusicKey: floatingMusicKey,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
