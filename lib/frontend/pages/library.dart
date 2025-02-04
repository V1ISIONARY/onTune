// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontune/frontend/pages/search.dart';
import 'package:page_transition/page_transition.dart';

import '../../backend/bloc/on_tune_bloc.dart';
import '../../backend/services/model/randomized.dart';
import '../widget/main_navigation.dart';
import '../widget/secret/search_section.dart';
import '../../resources/schema.dart';

class Library extends StatefulWidget {

  final VoidCallback Drawable;

  const Library({
    super.key,
    required this.Drawable
  });

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {

  final GlobalKey<MainWrapperState> drawerOpen = GlobalKey<MainWrapperState>();
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          width: double.infinity,
          child: Builder(builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: widget.Drawable,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'lib/resources/image/static-profile.jpeg',  // Use Image.asset for local images
                                fit: BoxFit.cover,  // Make sure the image covers the container
                              ),
                            ),
                          ),
                          // Text(
                          //   'Notification',
                          //   style: TextStyle(
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.w500,
                          //     color: Colors.white,
                          //   ),
                          // )
                        ]
                      )
                    ),
                  )
                ),
                SizedBox(width: 10),
                // Expanded(
                //   child: Container(
                //     height: 50,
                //     child: Center(
                //       child: Container(
                //         height: 30,
                //         child: ElevatedButton(
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               PageTransition(
                //                 child: Search(enableReturn: false),
                //                 type: PageTransitionType.fade,
                //                 duration: Duration(milliseconds: 300)
                //               )
                //             );
                //           }, 
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: widgetPricolor,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(5.0),
                //             ),
                //             elevation: 5,
                //           ),
                //           child: Container(
                //             width: double.infinity,
                //             child: Center(
                //               child: Transform.translate(
                //                 offset: Offset(-5, 0),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Container(
                //                       height: 40,
                //                       child: Center(
                //                         child: Icon(
                //                           size: 17,
                //                           Icons.search,
                //                           color: Colors.white54,
                //                         ),
                //                       )
                //                     ),
                //                     SizedBox(width: 5),
                //                     Container(
                //                       height: 40,
                //                       child: Center(
                //                         child: Text(
                //                           'Search songs',
                //                           style: TextStyle(color: Colors.white54, fontSize: 12.0, fontWeight: FontWeight.w400)
                //                         )
                //                       )
                //                     )
                //                   ],
                //                 )
                //               )
                //             )
                //           )
                //         ),
                //       )
                //     )
                //   ),
                // )
              ]
            );
          })
        )
      ),
      body: BlocConsumer<OnTuneBloc, OnTuneState>(
        listener: (context, state) {
          if (state is FetchExplorer) {
            // print("Fetched explorer list: ${state.explorerList.length}");
          }
        },
        builder: (context, state) {
          if (state is LoadingTune) {
            context.read<OnTuneBloc>().add(LoadTune());
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchExplorer) {

            final List<Randomized> songs = state.explorerList;
            List<dynamic> double_single = songs.take(20).toList();
            
            return ListView(
              children: [
                // LayoutBuilder(
                //   builder: (context, constraints) {
                //     return SizedBox(
                //       child: GridView.builder(
                //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 2,
                //           mainAxisSpacing: 10, // Minimized vertical spacing
                //           crossAxisSpacing: 10, // Minimized horizontal spacing
                //           childAspectRatio: 145 / 110 // Keep as needed
                //         ),
                //         itemCount: 20, // Set item count as required
                //         shrinkWrap: true, 
                //         physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling if needed
                //         padding: const EdgeInsets.symmetric(horizontal: 20), // Reduce overall padding around the grid
                //         itemBuilder: (_, index) => GridTile(
                //           child: SearchSection(
                //             song: double_single[index], 
                //           ),
                //         ),
                //       ),
                //     );
                //   }
                // )
              ],
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
      ),
    );
  }
}