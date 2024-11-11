// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:ontune/resources/widget/main_navigation.dart';
import 'package:page_transition/page_transition.dart';

class new_music extends StatefulWidget {
  const new_music({super.key});

  @override
  State<new_music> createState() => _new_musicState();
}

class _new_musicState extends State<new_music> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: InkWell(
          onTap: (){
            Navigator.push(
              context,
              PageTransition(
                child: MainWrapper(initialPage: 0),
                type: PageTransitionType.leftToRight,
                duration: Duration(milliseconds: 200)
              )
            );
          },
          child: Icon(
            size: 17,
            color: Colors.white,
            Icons.arrow_back_ios_new_outlined
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Text(
              "What's New",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold
              )
            ),
            Text(
              'The latest releases from artists, podcasts, and shows\n you follow.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10
              ),
            ),
            SizedBox(height: 10),
            Text(
              'New',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 80,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sept 28',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 9
                                    ),
                                  ),
                                  Text(
                                    'Get You',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17
                                    ),
                                  ),
                                  Text(
                                    'Arthur Nery',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Albums',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 9
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 30,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){},
                                  child: Icon(
                                    size: 25,
                                    color: Colors.white54,
                                    Icons.add_circle_outline_rounded
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: (){},
                                  child: Icon(
                                    size: 25,
                                    color: Colors.white54,
                                    Icons.linear_scale_sharp
                                  ),
                                )
                              ]
                            )
                          ),
                          Positioned(
                            right: 0,
                            child: InkWell(
                              onTap: (){},
                              child: Icon(
                                size: 25,
                                color: Colors.white,
                                Icons.play_circle_filled
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      color: Colors.white10,
                      width: double.infinity,
                      height: 1, // Height of the line
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      )
    );
  }
}