import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontune/frontend/pages/credentials/menu/profile.dart';
import 'package:ontune/frontend/pages/credentials/menu/settings.dart';
import 'package:ontune/frontend/pages/introduction/listening.dart';
import 'package:ontune/frontend/pages/home.dart';
import 'package:ontune/frontend/pages/library.dart';
import 'package:ontune/frontend/pages/search.dart';
import 'package:ontune/frontend/widget/secret/menuBtn.dart';
import 'package:ontune/resources/schema.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import '../../backend/cubit/bnc_cubit.dart';
import '../pages/credentials/menu/new_music.dart';
import '../pages/musicbox.dart';
import '../pages/notification.dart';
import 'floating_music.dart';

class MainWrapper extends StatefulWidget {
  final int initialPage; 
  const MainWrapper({
    super.key,
    required this.initialPage,
  }); 

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

  late List<Widget> topLevelPages;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
    topLevelPages = _initializeTopLevelPages(); 

    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _beginAnimation = Tween<Alignment>(
      begin: Alignment(-1.0, -1.0), 
      end: Alignment(1.0, 1.0),     
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _endAnimation = Tween<Alignment>(
      begin: Alignment(1.0, -1.0), 
      end: Alignment(-1.0, 1.0), 
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

  List<Widget> _initializeTopLevelPages() {
    return [
      Home(onToggle: toggleContainer, Drawable: drawerOpen),
      Search(enableReturn: true, onToggle: toggleContainer),
      Musicbox(),
      Library(Drawable: drawerOpen),
      Notif()
    ];
  }

  void toggleContainer() {
    setState(() {
      _floatingMusicKey.currentState?.toggleContainer();
    });
  }

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
      backgroundColor: Colors.transparent, 
      extendBody: true, 
      body: _mainWrapperBody(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          FloatingMusic(key: _floatingMusicKey, initialAudioUrl: ''),
          _mainWrapperBottomNavBar(context),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  PageTransition(
                    child: Profile(accId: '1', onToggle: () {  }, initialPage: 0),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 200)
                  )
                );
              },
              child: Container(
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
                        child: ClipOval(
                          child: Image.asset(
                            'lib/resources/image/static-profile.jpeg', 
                            fit: BoxFit.cover, 
                          ),
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
              )
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white10,
            ),
            Menubtn(
              title: 'Add account', 
              description: '', 
              svgIcon: Icon(Icons.add_box_outlined), 
              navigateTo: 'Listening',
            ),
            Menubtn(
              title: 'Import', 
              description: 'Import your downloaded music here', 
              svgIcon: Icon(Icons.import_export_sharp), 
              navigateTo: '',
            ),
            Menubtn(
              title: 'New Music', 
              description: '', 
              svgIcon: Icon(Icons.electric_bolt_sharp), 
              navigateTo: 'New',
            ),
            Menubtn(
              title: 'Listening history', 
              description: '', 
              svgIcon: Icon(Icons.access_time), 
              navigateTo: '',
            ),
            Menubtn(
              title: 'Settings and privacy', 
              description: 'Customize your settings', 
              svgIcon: Icon(Icons.settings), 
              navigateTo: 'Settings',
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    // Positioned(
                    //   bottom: 21,
                    //   right: 20,
                    //   child: GestureDetector(
                    //     child: Icon(
                    //       Icons.door_front_door_rounded,
                    //       color: Colors.white,
                    //     ),
                    //   )
                    // ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Container(
                              width: 2,
                              height: 18,
                              color: Colors.white
                            ),
                          ),
                          SvgPicture.asset(
                            'lib/resources/svg/logo.svg',
                            height: 17,
                            width: 17,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Visionary',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10
                                  ),
                                ),
                                Text(
                                  'Prototype 0.0.1',
                                  style: TextStyle(
                                    color: Colors.white24,
                                    fontSize: 8
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }

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
                      // _bottomAppBarItem(
                      //   context,
                      //   icon: Icons.linear_scale_outlined, // Use IconData for Library
                      //   svgIcon: '', // Optional SVG if preferred
                      //   page: 2,
                      //   label: "Music Box",
                      // ),
                      // _bottomAppBarItem(
                      //   context,
                      //   icon: Icons.library_music_outlined, // Use IconData for Library
                      //   svgIcon: '', // Optional SVG if preferred
                      //   page: 3,
                      //   label: "My Library",
                      // ),
                      // _bottomAppBarItem(
                      //   context,
                      //   icon: Icons.notifications_on, // Use IconData for Library
                      //   svgIcon: '', // Optional SVG if preferred
                      //   page: 4,
                      //   label: "Notification",
                      // ),
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
