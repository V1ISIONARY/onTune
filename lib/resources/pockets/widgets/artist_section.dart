import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ontune/resources/pockets/widgets/actions/artist.dart';

import '../../../backend/services/model/randomized.dart';

class ArtistSection extends StatelessWidget {

  final String title;
  final String subtitle;
  final List<Randomized> listahan;

  const ArtistSection({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.listahan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a Map to count occurrences of each artist
    Map<String, int> artistCount = {};
    for (var artist in listahan) {
      artistCount[artist.musicWriter] = (artistCount[artist.musicWriter] ?? 0) + 1;
    }

    // Filter the list to include only artists that appear at least twice
    List<Randomized> repeatedArtists = listahan.where((artist) {
      return artistCount[artist.musicWriter]! >= 3;
    }).toList();

    // Create a Set to track unique artist names among the repeated artists
    Set<String> seenArtists = {};

    // Filter to get unique artists from the repeated artists list
    List<Randomized> uniqueRepeatedArtists = repeatedArtists.where((artist) {
      if (seenArtists.contains(artist.musicWriter)) {
        return false; // Skip if the artist is already seen
      } else {
        seenArtists.add(artist.musicWriter); // Add the artist name to the set
        return true;
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSans(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.notoSans(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 8.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                )
              )
            ]
          ),
        ),
        SizedBox(
          height: 130, // Keep the grid height fixed
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                (uniqueRepeatedArtists.length / 2).ceil(),
                (columnIndex) {
                  final startIndex = columnIndex * 2;
                  final endIndex = startIndex + 2;
                  final artistsInColumn = uniqueRepeatedArtists.sublist(
                    startIndex,
                    endIndex > uniqueRepeatedArtists.length ? uniqueRepeatedArtists.length : endIndex,
                  );
                  return Column(
                    children: artistsInColumn.map((artist) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Artist(
                          artistName: artist.musicWriter,
                          artistUrl: artist.playlistUrl,
                          followers: artist.subscribers,
                          writerLogo: artist.thumnail,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}