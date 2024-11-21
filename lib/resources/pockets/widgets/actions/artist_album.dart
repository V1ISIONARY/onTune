// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import '../../../schema.dart';
import '../../designs/textLimit.dart';

class artist_album extends StatelessWidget {

  final String albumArtist;
  final String songsCount;
  final String albumTitle;
  final String albumUrl;
  final String thumnail;

  const artist_album({
    super.key,
    required this.albumArtist,
    required this.songsCount,
    required this.albumTitle,
    required this.albumUrl,
    required this.thumnail
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        width: 190,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 190,
              height: 140,
              child: Stack(
                children:[
                  Container(
                    width: 140,
                    height: 140,
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)
                      ),
                      child: Image.network(
                        "https://static.vecteezy.com/system/resources/previews/009/393/830/original/black-vinyl-disc-record-for-music-album-cover-design-free-png.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: primary_color,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5)
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5)
                        ),
                        child: Image.network(
                          thumnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ]
              )
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  limitText(albumTitle, 18),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(height: 2),
                Container(
                  width: double.infinity,
                  height: 15,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                        limitText(albumArtist, 20), 
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Text(
                          limitText(songsCount, 20), 
                            style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                      )
                    ],
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