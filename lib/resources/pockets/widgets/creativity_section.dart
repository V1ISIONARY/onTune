import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreativitySection extends StatelessWidget {
  const CreativitySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Creativity',
            style: GoogleFonts.notoSans(
              textStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w900)
            )
          ),
          Text(
            'Featuring our friendly and free music player for public users',
            style: TextStyle(color: Colors.white54, fontSize: 10.0)
          ),
        ],
      )
    );
  }
}