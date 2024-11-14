// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../schema.dart';
import '../../designs/textLimit.dart';

class multiple_music_action extends StatelessWidget {

  final String combineImages;
  final String playlistLink;
  final String userImage;
  final String username;
  final String title;
  final String viewers;

  const multiple_music_action({
    super.key,
    required this.combineImages,
    required this.playlistLink,
    required this.userImage,
    required this.username,
    required this.title,
    required this.viewers
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
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
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  combineImages,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Image.network(
                                  combineImages,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  combineImages,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Image.network(
                                  combineImages,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        width: 30, // Adjust to account for the border
                        height: 30,
                        padding: EdgeInsets.all(1.0), // Padding for the border
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0, // Border thickness
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            userImage,
                            fit: BoxFit.cover,
                            width: 32, // Inner image size
                            height: 32,
                          ),
                        ),
                      ),
                    )
                  ]
                )
              )
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  limitText(title, 25),
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
                        limitText(username, 20), 
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
                          limitText("192K views", 20), 
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
