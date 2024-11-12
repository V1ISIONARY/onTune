// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontune/frontend/search.dart';
import 'package:page_transition/page_transition.dart';

import '../backend/bloc/on_tune_bloc.dart';
import '../backend/services/model/randomized.dart';
import '../resources/schema.dart';
import '../resources/widget/floating_music.dart';
import '../resources/widget/main_navigation.dart';
import '../resources/widget/single_music_widget.dart';

class Home extends StatefulWidget {
  final VoidCallback onToggle; // Add a callback parameter
  final VoidCallback Drawable; // Add a callback parameter

  const Home({super.key, required this.onToggle, required this.Drawable});

  static ValueNotifier<String> updatedWriter = ValueNotifier<String>('');
  static ValueNotifier<String> updatedTitle = ValueNotifier<String>('');
  static ValueNotifier<String> updatedUrl = ValueNotifier<String>('');
  static ValueNotifier<String> updatedIcon = ValueNotifier<String>('');

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<MainWrapperState> drawerOpen = GlobalKey<MainWrapperState>();
  final GlobalKey<FloatingMusicState> floatingMusicKey = GlobalKey<FloatingMusicState>();

  @override
  void initState() {
    super.initState();
    context.read<OnTuneBloc>().add(LoadTune());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Container(
          width: double.infinity,
          child: Builder(builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  child: Center(
                    child: InkWell(
                      onTap: (){
                        widget.Drawable();
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                        ),
                      ),
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Container(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              PageTransition(
                                child: Search(enableReturn: false),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 200)
                              )
                            );
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widgetPricolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0), // Rounded corners
                            ),
                            elevation: 5, // Shadow elevation
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Center(
                                      child: Icon(
                                        size: 17,
                                        Icons.search,
                                        color: Colors.white54,
                                      ),
                                    )
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        'Search songs',
                                        style: TextStyle(color: Colors.white54, fontSize: 12.0, fontWeight: FontWeight.w500)
                                      )
                                    )
                                  )
                                ],
                              )
                            )
                          )
                        ),
                      )
                    )
                  ),
                )
              ]
            );
          })
        )
      ),
      body: BlocConsumer<OnTuneBloc, OnTuneState>(
        listener: (context, state) {
          if (state is FetchExplorer) {
            print("Fetched explorer list: ${state.explorerList.length}");
          }
        },
        builder: (context, state) {
          if (state is LoadingTune) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchExplorer) {
            final List<Randomized> songs = state.explorerList;
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    height: 30,
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: InkWell(
                          onTap: (){},
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: primary_color,
                              borderRadius: BorderRadius.circular(2)
                            ),
                            child: Center(
                              child: Text(
                                'Music',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400
                                ),
                              )
                            )
                          )
                        )
                      )
                    ) 
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Creativity',
                          style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                        ),
                        Text(
                          'Featuring our friendly and free music player for public users',
                          style: TextStyle(color: Colors.white54, fontSize: 10.0)
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 300,
                      height: 130,
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: primary_color,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   'LOVE',
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w900, // Maximum thickness
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              'Popular Today',
                              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                            )
                          ),
                          Positioned(
                            right: 20,
                            top: 2,
                            bottom: 2,
                            child: InkWell(
                              onTap: (){},
                              child: Text('View all >',
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
                    child: Row(
                      children: List.generate(
                        songs.length,
                        (index) {
                          final song = songs[index];
                          return single_music_widget(
                            onToggle: widget.onToggle,
                            musicTitle: song.musicTitle,
                            musicWriter: song.musicWriter,
                            audioUrl: song.audioUrl,
                            thumbnail: song.thumnail,
                            floatingMusicKey: floatingMusicKey
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20, left: 20),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              'Recommended For Today',
                              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                            )
                          ),
                          Positioned(
                            right: 20,
                            top: 2,
                            bottom: 2,
                            child: InkWell(
                              onTap: (){},
                              child: Text('View all >',
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
                      width: 140,
                      height: 190,
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
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
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Happier Than Ever',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Billie Elish', 
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20, left: 20),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              'My Playlist',
                              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                            )
                          ),
                          Positioned(
                            right: 20,
                            top: 2,
                            bottom: 2,
                            child: InkWell(
                              onTap: (){},
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
                                _truncateText('The second', 25),
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
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
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
                                          style: TextStyle(color: Colors.white, fontSize: 17.0)
                                        )
                                      ],
                                    )
                                  )
                                )
                              ],
                            )
                          ),
                          Positioned(
                            right: 20,
                            top: 2,
                            bottom: 2,
                            child: InkWell(
                              onTap: (){},
                              child: Center( 
                                child: Text('View all >',
                                  style: TextStyle(color: Colors.white38, fontSize: 10.0)
                                )
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
                      width: 140,
                      height: 190,
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
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
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _truncateText('Dizzy Gillespie, Duke Ellington, Mark Egan', 24),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Jazz', 
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20, left: 20),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              'Recomended stations',
                              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                            )
                          ),
                          Positioned(
                            right: 20,
                            top: 2,
                            bottom: 2,
                            child: InkWell(
                              onTap: (){},
                              child: Text('View all >',
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
                      width: 140,
                      height: 190,
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
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
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Happier Than Ever',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Billie Elish', 
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              'New Released Songs',
                              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                            )
                          ),
                        ],
                      ),
                    )
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 10, left: 20),
                  //   child: Container(
                  //     width: double.infinity,
                  //     child: Stack(
                  //       children: [
                  //         Positioned(
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               SizedBox(width: 20),
                  //               Text(
                  //                 'Rank',
                  //                 style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.w500)
                  //               ),
                  //               SizedBox(width: 20),
                  //               Container(
                  //                 color: Colors.white54,
                  //                 width: 1,
                  //                 height: 20,
                  //               ),
                  //             ],
                  //           )
                  //         ),
                  //         Positioned(
                  //           right: 40,
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Container(
                  //                 color: Colors.white54,
                  //                 width: 1,
                  //                 height: 20,
                  //               ),
                  //               SizedBox(width: 20),
                  //               Text(
                  //                 'Album',
                  //                 style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.w500)
                  //               ),
                  //             ],
                  //           )
                  //         ),
                  //       ],
                  //     ),
                  //   )
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      color: Colors.white54,
                      height: 1,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: List.generate(2, (index) {
                            return InkWell(
                              onTap:(){},
                              child: Container(
                                height: 40,
                                width: double.infinity, // Fixed width for each container
                                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Container(
                                          //   child: Center(
                                          //     child: Text(
                                          //       '1',
                                          //       style: TextStyle(
                                          //         fontSize: 17,
                                          //         color: Colors.white54,
                                          //         fontWeight: FontWeight.w300
                                          //       ),
                                          //     ),
                                          //   )
                                          // ),
                                          // SizedBox(width: 40),
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(2)
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.symmetric(horizontal: 1),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                  'APT',
                                                    style: TextStyle(color: Colors.white, fontSize: 13.0)
                                                  ),
                                                  Text(
                                                    'ROSE, Bruno Mars',
                                                    style: TextStyle(color: Colors.white54, fontSize: 8.0)
                                                  )
                                                ],
                                              ),
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        height: 40,
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          '2:00',
                                          style: TextStyle(color: Colors.white54, fontSize: 10.0)
                                        )
                                      ) 
                                    )
                                  ]
                                )
                              )
                            );
                          }),
                        ),
                        Container(
                          height: 40,
                          width: double.infinity,
                          child: InkWell(
                            onTap: (){}, 
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: Colors.black,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(0), 
                            //   ),
                            // ),
                            child: Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 12,
                                      bottom: 12,
                                      child: Text(
                                        'See more',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      )
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 12,
                                      bottom: 12,
                                      child: Icon(
                                        size: 15,
                                        color: Colors.white,
                                        Icons.arrow_forward_ios
                                      )
                                    )
                                  ]
                                )
                              )
                            )
                          )
                        ),
                      ]
                    )
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          } else if (state is ErrorTune) {
            return Center(
              child: Text(
                "Error: ${state.response}",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return const SizedBox.shrink();
          
        }
      )
    );
  }
}

String _truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return text.substring(0, maxLength) + '...';
}