import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ontune/frontend/widget/secret/actions/artist_album.dart';
import '../floating_music.dart';

class AlbumSection extends StatelessWidget {
  
  final String title;
  final List<dynamic> songs;

  const AlbumSection({
    Key? key,
    required this.title,
    required this.songs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    title,
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w800)
                    )
                  )
                ),
                Positioned(
                  right: 20,
                  top: 2,
                  bottom: 2,
                  child: InkWell(
                    onTap: () {},
                    child: Text('View all >',
                      style: TextStyle(color: Colors.white38, fontSize: 10.0)
                    )
                  )
                )
              ],
            ),
          )
        ),
        Container(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 10),
                child: artist_album(
                  albumArtist: song.musicWriter, 
                  songsCount: "21 Songs", 
                  albumTitle: song.musicTitle, 
                  albumUrl: song.playlistUrl, 
                  thumnail: song.thumnail
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}