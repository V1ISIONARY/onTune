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
              child: InkWell(
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
            height: 300,
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
                        "writerLogo",
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
                    padding: EdgeInsets.only(top: 10, bottom: 10),
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
          // Padding(
          //   padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
          //   child: Container(
          //     width: double.infinity,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "History",
          //           style: GoogleFonts.notoSans(
          //           textStyle: TextStyle(
          //             color: Colors.white,
          //               fontSize: 20.0,
          //               fontWeight: FontWeight.w900,
          //             ),
          //           ),
          //         ),
          //         SizedBox(height: 20),
          //         InkWell(
          //           onTap: () {
          //           },
          //           child: Container(
          //             width: 140,
          //             height: 185,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(5),
          //               shape: BoxShape.rectangle,
          //             ),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Container(
          //                   width: double.infinity,
          //                   height: 140,
          //                   decoration: BoxDecoration(
          //                     color: primary_color,
          //                     borderRadius: BorderRadius.circular(5),
          //                     shape: BoxShape.rectangle,
          //                   ),
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(5),
          //                     child: Image.network(
          //                       "thumbnail",
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(height: 20),
          //                 Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       limitText("musicTitle", 18),
          //                       style: TextStyle(
          //                         fontSize: 12,
          //                         color: Colors.white,
          //                         fontWeight: FontWeight.w400
          //                       ),
          //                     ),
          //                     SizedBox(height: 2),
          //                     Text(
          //                       limitText("musicWriter", 18), 
          //                       style: TextStyle(
          //                         fontSize: 10,
          //                         color: Colors.grey,
          //                         fontWeight: FontWeight.w300
          //                       ),
          //                     )
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ),
          //         )
          //       ]
          //     )
          //   )
          // ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 20),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "Playlist",
          //         style: GoogleFonts.notoSans(
          //           textStyle: TextStyle(
          //             color: Colors.white,
          //             fontSize: 20.0,
          //             fontWeight: FontWeight.w900,
          //           ),
          //         ),
          //       ),
          //       SizedBox(height: 20),
          //       ListView.builder(
          //         shrinkWrap: true,
          //         physics: NeverScrollableScrollPhysics(),
          //         itemCount: 2,
          //         itemBuilder: (context, index) {
          //           return InkWell(
          //             onTap: () {},
          //             child: Container(
          //               height: 40,
          //               width: double.infinity,
          //               margin: EdgeInsets.only(top: 10, bottom: 10),
          //               child: Row(
          //                 children: [
          //                   Container(
          //                     height: 40,
          //                     width: 40,
          //                     decoration: BoxDecoration(
          //                       color: Colors.white,
          //                       borderRadius: BorderRadius.circular(2),
          //                     ),
          //                   ),
          //                   SizedBox(width: 10),
          //                   Expanded(
          //                     child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           'APT',
          //                           style: TextStyle(color: Colors.white, fontSize: 13.0),
          //                         ),
          //                         Text(
          //                           'ROSE, Bruno Mars',
          //                           style: TextStyle(color: Colors.white54, fontSize: 8.0),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Text(
          //                     '2:00',
          //                     style: TextStyle(color: Colors.white54, fontSize: 10.0),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // )
        ]
      )
    );
  }
}