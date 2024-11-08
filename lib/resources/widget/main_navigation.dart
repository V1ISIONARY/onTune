import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontune/frontend/home.dart';
import 'package:ontune/frontend/library.dart';
import 'package:ontune/frontend/search.dart';
import 'package:ontune/resources/schema.dart';
import 'package:page_transition/page_transition.dart';
import '../../backend/cubit/bnc_cubit.dart';
import 'menu/new_music.dart';
import 'floating_music.dart';

class MainWrapper extends StatefulWidget {
  final int initialPage; // New parameter to accept the initial page index
  const MainWrapper({super.key, required this.initialPage}); // Constructor update

  @override
  State<MainWrapper> createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> with SingleTickerProviderStateMixin {
  late PageController pageController;
  final GlobalKey<FloatingMusicState> _floatingMusicKey = GlobalKey<FloatingMusicState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Store the top level pages
  late List<Widget> topLevelPages;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage); // Set initial page
    topLevelPages = _initializeTopLevelPages(); // Initialize topLevelPages
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// Initialize topLevelPages
  List<Widget> _initializeTopLevelPages() {
    return [
      Home(onToggle: toggleContainer, Drawable: drawerOpen), // Pass toggleContainer to Home
      Search(enableReturn: true),
      Library(),
    ];
  }

  void toggleContainer() {
    setState(() {
      _floatingMusicKey.currentState?.toggleContainer();
    });
  }

  /// on Page Changed
  void onPageChanged(int page) {
    BlocProvider.of<bnc>(context).changeSelectedIndex(page);
  }

  void drawerOpen() {
    setState((){
      _scaffoldKey.currentState?.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black, // Set the scaffold background to transparent
      body: _mainWrapperBody(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // Ensure it takes minimum height
        children: [
          // InkWell(
          //   onTap: toggleContainer,
          //   child: FloatingMusic(key: _floatingMusicKey),
          // ),
          FloatingMusic(key: _floatingMusicKey),
          _mainWrapperBottomNavBar(context), // Keep the bottom navigation bar below
        ],
      ),
      drawer: Drawer(
        clipBehavior: Clip.none,
        child: Container(
          width: 200,
          height: double.infinity,
          decoration: BoxDecoration(
            color: primary_color,
            borderRadius: BorderRadius.zero
          ),
          child: ListView(
            children: [
              Container(
                height: 60,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              'Frank Sinatra',
                                style: TextStyle(color: Colors.white, fontSize: 14.0)
                              ),
                              Text(
                              'View Profile',
                                style: TextStyle(color: Colors.white54, fontSize: 10.0)
                              )
                            ],
                          )
                        )
                      )
                    ],
                  )
                )
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.white10,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary_color,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rounded corners
                        ),
                        elevation: 0
                      ),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                child: Center(
                                  child: Icon(
                                    size: 25,
                                    Icons.add_box_outlined,
                                    color: Colors.white,
                                  ),
                                )
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 40,
                                child: Center(
                                  child: Text(
                                    'Add account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  )
                                ),
                              )
                            ],
                          )
                        )
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary_color,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rounded corners
                        ),
                        elevation: 0
                      ),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                child: Center(
                                  child: Icon(
                                    size: 25,
                                    Icons.import_export_sharp,
                                    color: Colors.white,
                                  ),
                                )
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 40,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Import",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Import your downloaded musics here",
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 10,
                                        ),
                                      )
                                    ]
                                  ),
                                ),
                              )
                            ],
                          )
                        )
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          PageTransition(
                            child: new_music(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200)
                          )
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary_color,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rounded corners
                        ),
                        elevation: 0
                      ),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                child: Center(
                                  child: Icon(
                                    size: 25,
                                    Icons.electric_bolt_sharp,
                                    color: Colors.white,
                                  ),
                                )
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 40,
                                child: Center(
                                  child: Text(
                                    "What's new",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  )
                                ),
                              )
                            ],
                          )
                        )
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   PageTransition(
                        //     child: new_music(),
                        //     type: PageTransitionType.rightToLeft
                        //   )
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary_color,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rounded corners
                        ),
                        elevation: 0
                      ),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                child: Center(
                                  child: Icon(
                                    size: 25,
                                    Icons.access_time,
                                    color: Colors.white,
                                  ),
                                )
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 40,
                                child: Center(
                                  child: Text(
                                    "Listening history",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  )
                                ),
                              )
                            ],
                          )
                        )
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary_color,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rounded corners
                        ),
                        elevation: 0
                      ),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                child: Center(
                                  child: Icon(
                                    size: 25,
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                )
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 40,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Settings and privacy",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Customize your settings",
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 10,
                                        ),
                                      )
                                    ]
                                  )
                                ),
                              )
                            ],
                          )
                        )
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  // Bottom Navigation Bar - MainWrapper Widget
  BottomAppBar _mainWrapperBottomNavBar(BuildContext context) {
    return BottomAppBar(
      height: 69,
      color: primary_color, // Keep a solid color for the BottomAppBar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomAppBarItem(
                  context,
                  defaultIcon: Icons.home,
                  page: 0,
                  label: "Home",
                  filledIcon: Icons.home,
                ),
                _bottomAppBarItem(
                  context,
                  defaultIcon: Icons.search,
                  page: 1,
                  label: "Search",
                  filledIcon: Icons.search_outlined,
                ),
                _bottomAppBarItem(
                  context,
                  defaultIcon: Icons.library_music_outlined,
                  page: 2,
                  label: "Library",
                  filledIcon: Icons.library_music,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Body - MainWrapper Widget
  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: (int page) => onPageChanged(page),
      controller: pageController,
      children: topLevelPages,
    );
  }

  double iconSize = 20.0;
  double fontSize = 8.0;

  // Bottom Navigation Bar Single item - MainWrapper Widget
  Widget _bottomAppBarItem(
    BuildContext context, {
    required IconData defaultIcon,
    required int page,
    required String label,
    required IconData filledIcon,
  }) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<bnc>(context).changeSelectedIndex(page);
        pageController.animateToPage(page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.transparent, // Ensure the icon area is also transparent
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5),
                    Icon(
                      context.watch<bnc>().state == page ? filledIcon : defaultIcon,
                      color: context.watch<bnc>().state == page ? Colors.white : Colors.grey,
                      size: iconSize,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      style: TextStyle(
                        color: context.watch<bnc>().state == page ? Colors.white : Colors.grey,
                        fontSize: fontSize,
                        fontWeight: context.watch<bnc>().state == page ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
