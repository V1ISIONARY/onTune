// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:ontune/frontend/widget/floating_music.dart';
import '../../../pages/home.dart';
import '../../../../resources/schema.dart';
import '../../designs/textLimit.dart';

class single_music_action extends StatelessWidget {

  final GlobalKey<FloatingMusicState> floatingMusicKey;
  final VoidCallback onToggle; 
  final String musicTitle;
  final String musicWriter;
  final String audioUrl;
  final String thumbnail;

  const single_music_action({
    super.key,
    required this.onToggle,
    required this.musicTitle,
    required this.musicWriter,
    required this.audioUrl,
    required this.thumbnail,
    required this.floatingMusicKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onToggle();
        Home.updatedUrl.value = audioUrl;
        Home.updatedTitle.value = musicTitle;
        Home.updatedWriter.value = musicWriter;
        Home.updatedIcon.value = thumbnail;
      },
      child: Container(
        width: 140,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: primary_color,
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  limitText(musicTitle, 18),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  limitText(musicWriter, 18), 
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}