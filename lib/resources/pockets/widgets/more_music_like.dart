import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../schema.dart';
import 'actions/single_music_action.dart';
import '../floating_music.dart';

class MoreMusicLike extends StatelessWidget {

  final String title;
  final List<dynamic> songs;
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
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 10, left: 20),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned(
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
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 40,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                              'More Music like',
                                style: TextStyle(color: Colors.white, fontSize: 10.0)
                              ),
                              Text(
                              'Frank Sinatra',
                              style: GoogleFonts.notoSans(
                                  textStyle: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w800)
                                )
                              )
                            ],
                          )
                        )
                      )
                    ],
                  )
                ),
              ]
            ),
            SizedBox(height: 20),
            Container(
              height: 180,
              child: Transform.translate(
                offset: Offset(-20.0, 0.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
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
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}