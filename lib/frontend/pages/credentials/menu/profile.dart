// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../backend/cubit/bnc_cubit.dart';
import '../../resources/pockets/main_navigation.dart';
import 'menu/profile/favorite.dart';
import 'menu/profile/heart.dart';
import 'menu/profile/myplaylist.dart';
import 'menu/profile/private_playlist.dart';
import 'menu/profile/recent.dart';

class Profile extends StatefulWidget {
  final String accId;
  final int initialPage;
  final VoidCallback onToggle;

  const Profile({
    Key? key,
    required this.accId,
    required this.onToggle,
    required this.initialPage,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  
  late final PageController pageController;
  late final List<Widget> topLevelPages;
  late final AnimationController animationController;

  final double iconSize = 25.0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
    topLevelPages = _initializeTopLevelPages();

    animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  List<Widget> _initializeTopLevelPages() {
    return [
      MyPlaylist(),
      PrivatePlaylist(),
      Favorite(),
      Recent(),
      Heart(),
    ];
  }

  void onPageChanged(int page) {
    BlocProvider.of<bnc>(context).changeSelectedIndex(page);
  }

  Widget _mainWrapperBody() {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: topLevelPages,
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
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
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _credentialBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(65),
              child: Image.asset(
                'lib/resources/images/static-profile.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Louise Romero",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "2k Followers | 377 Follows | 1024 Likes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyNavigator(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomAppBarItem(Icons.library_music_outlined, 0),
              _bottomAppBarItem(Icons.lock_outlined, 1),
              _bottomAppBarItem(Icons.bookmark_outline, 2),
              _bottomAppBarItem(Icons.access_time, 3),
              _bottomAppBarItem(Icons.heart_broken_outlined, 4),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomAppBarItem(IconData icon, int page) {
    return GestureDetector(
      onTap: () {
        pageController.jumpToPage(page);
        onPageChanged(page);
      },
      child: BlocBuilder<bnc, int>(
        builder: (context, selectedIndex) {
          final isSelected = selectedIndex == page;
          return Icon(
            icon,
            size: iconSize,
            color: isSelected ? Colors.white : Colors.grey,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _appBar(context),
      ),
      body: Column(
        children: [
          _credentialBody(context), // This is your profile body
          _bodyNavigator(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              color: Colors.white10,
              height: 1,
              width: double.infinity,
            ),
          ),
          Expanded(child: _mainWrapperBody()), // Main body for the PageView
        ],
      ),
    );
  }
}
