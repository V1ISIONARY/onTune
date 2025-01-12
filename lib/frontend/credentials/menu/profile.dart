// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../backend/services/model/randomized.dart';
import '../../../resources/pockets/designs/fade.dart';
import '../../../resources/pockets/designs/textLimit.dart';
import '../../../resources/pockets/floating_music.dart';
import '../../../resources/pockets/main_navigation.dart';
import '../../../resources/pockets/widgets/music_section.dart';
import '../../../resources/pockets/widgets/new_released_songs.dart';
import '../../../resources/schema.dart';

class profile extends StatefulWidget {

  final String accId;
  final VoidCallback onToggle;

  const profile({
    super.key,
    required this.accId,
    required this.onToggle
  });

  @override
  State<profile> createState() => _profileState();

}

class _profileState extends State<profile> {
  
  final GlobalKey<FloatingMusicState> floatingMusicKey = GlobalKey<FloatingMusicState>();
  List<String> songs = ['Apple', 'Banana', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: MainWrapper(initialPage: 0),
                      type: PageTransitionType.leftToRight,
                      duration: const Duration(milliseconds: 200),
                    ),
                  );
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            ),
            const Center(
              child: Text(
                "@ruviro",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13, // Adjust font size for better visibility
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 270,
            color: Colors.black, 
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey, // Placeholder color
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'lib/resources/images/static-profile.jpeg',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Louise Romero",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13, // Adjust font size for better visibility
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "2k Followers | 377 Follows | 1024 Likes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11, // Adjust font size for better visibility
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
          Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: 60,
                          child: Icon(
                            Icons.library_music_outlined,
                            color: Colors.white70,
                            size: 25,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: 60,
                          child: Icon(
                            Icons.lock_outlined,
                            color: Colors.white30,
                            size: 25,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: 60,
                          child: Icon(
                            Icons.bookmark_outline,
                            color: Colors.white30,
                            size: 25,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: 60,
                          child: Icon(
                            Icons.access_time,
                            color: Colors.white30,
                            size: 25,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: 60,
                          child: Icon(
                            Icons.heart_broken_outlined,
                            color: Colors.white30,
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  )
                )
              ]
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 15),
            child: Container(
              color: Colors.white10,
              width: double.infinity,
              height: 1, // Height of the line
            ),
          ),
        ]
      )
    );
  }
}