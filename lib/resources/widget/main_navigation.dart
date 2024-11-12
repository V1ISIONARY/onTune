import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontune/frontend/home.dart';
import 'package:ontune/frontend/library.dart';
import 'package:ontune/frontend/search.dart';
import 'package:ontune/resources/schema.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this for SvgPicture
import '../../backend/cubit/bnc_cubit.dart';
import 'menu/new_music.dart';
import 'floating_music.dart';

class MainWrapper extends StatefulWidget {
  final int initialPage; // New parameter to accept the initial page index
  const MainWrapper({
    super.key,
    required this.initialPage,
  }); // Constructor update

  @override
  State<MainWrapper> createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> with SingleTickerProviderStateMixin {
  final GlobalKey<FloatingMusicState> _floatingMusicKey = GlobalKey<FloatingMusicState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<String> audioUrlNotifier = ValueNotifier<String>('');
  late PageController pageController;
  late AnimationController _controller;
  late Animation<Alignment> _beginAnimation;
  late Animation<Alignment> _endAnimation;

  // Store the top-level pages
  late List<Widget> topLevelPages;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage); // Set initial page
    topLevelPages = _initializeTopLevelPages(); // Initialize topLevelPages

    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _beginAnimation = Tween<Alignment>(
      begin: Alignment(-1.0, -1.0), // Start outside the top-left corner
      end: Alignment(1.0, 1.0),     // End outside the bottom-right corner
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _endAnimation = Tween<Alignment>(
      begin: Alignment(1.0, -1.0), // Start outside the top-right corner
      end: Alignment(-1.0, 1.0),   // End outside the bottom-left corner
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

  }

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  /// Initialize top-level pages
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
    setState(() {
      _scaffoldKey.currentState?.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent, // Set the scaffold background to transparent
      extendBody: true, // Make sure the body extends behind the AppBar if there is one
      body: _mainWrapperBody(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // Ensure it takes minimum height
        children: [
          FloatingMusic(key: _floatingMusicKey, initialAudioUrl: ''),
          _mainWrapperBottomNavBar(context), // Keep the bottom navigation bar below
        ],
      ),
      drawer: _drawer(context)
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
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
    );
  }

  // Bottom Navigation Bar - MainWrapper Widget
  Widget _mainWrapperBottomNavBar(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller, // Attach the animation controller
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _beginAnimation.value,  // Animated alignment value
              end: _endAnimation.value,      // Animated alignment value
              colors: [
                Color.fromARGB(178, 0, 0, 0),
                Color.fromARGB(200, 24, 24, 24),
                Color.fromARGB(255, 0, 0, 0),
              ],
              stops: [0.2, 0.5, 1.0],
            ),
          ),
          child: BottomAppBar(
            height: 69,
            color: Colors.transparent, // Keep a solid color for the BottomAppBar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _bottomAppBarItem(
                        context,
                        icon: Icons.home, // No IconData since we’re using an SVG here
                        svgIcon: 'lib/resources/svg/explore.svg', // Use SVG for Home
                        page: 0,
                        label: "Explore",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: Icons.search, // Use IconData for Search
                        svgIcon: '', // Empty SVG path as we're using IconData
                        page: 1,
                        label: "Search",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: Icons.library_music_outlined, // Use IconData for Library
                        svgIcon: '', // Optional SVG if preferred
                        page: 2,
                        label: "My Library",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: Icons.library_music_outlined, // Use IconData for Library
                        svgIcon: '', // Optional SVG if preferred
                        page: 2,
                        label: "My Library",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: Icons.library_music_outlined, // Use IconData for Library
                        svgIcon: '', // Optional SVG if preferred
                        page: 2,
                        label: "My Library",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        );
      }
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
    required IconData icon,
    required String svgIcon,
    required int page,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        pageController.jumpToPage(page);
        onPageChanged(page);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<bnc, int>(
            builder: (context, selectedIndex) {
              bool isSelected = selectedIndex == page;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: svgIcon.isNotEmpty
                    ? SvgPicture.asset(
                        svgIcon,
                        height: iconSize,
                        color: isSelected ? Colors.white : Colors.grey,
                      )
                    : Icon(
                        icon,
                        size: iconSize,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
