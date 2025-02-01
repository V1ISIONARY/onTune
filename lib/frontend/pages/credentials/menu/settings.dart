import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../widget/main_navigation.dart';

class Settings extends StatefulWidget {


  const Settings({
    super.key
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _appBar(context),
      ),
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
              "Settings",
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
  
}