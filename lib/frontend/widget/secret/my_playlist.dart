import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ontune/resources/pockets/designs/textLimit.dart';
import '../../schema.dart';

class MyPlaylist extends StatelessWidget {
  const MyPlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20, left: 20),
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    'My Playlist',
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
                    child: Text('View my playlist >',
                      style: TextStyle(color: Colors.white38, fontSize: 10.0)
                    )
                  )
                )
              ],
            ),
          )
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 180,
            height: 50,
            margin: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: primary_color,
              borderRadius: BorderRadius.circular(2),
              shape: BoxShape.rectangle,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2),
                      bottomLeft: Radius.circular(2)
                    ),
                    color: tertiary_color,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      limitText('The second', 25),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w100
                      ),
                    ),
                  ),
                )
              ],
            )
          )
        ),
      ],
    );
  }
  
}