import 'package:flutter/material.dart';
import 'package:ontune/frontend/pages/credentials/menu/settings.dart';
import 'package:ontune/frontend/pages/introduction/listening.dart';
import 'package:page_transition/page_transition.dart';

import '../../pages/credentials/menu/new_music.dart';

class Menubtn extends StatefulWidget {
  final String title;
  final String description;
  final Icon svgIcon;
  final String navigateTo;

  const Menubtn({
    super.key,
    required this.title,
    required this.description,
    required this.svgIcon,
    required this.navigateTo,
  });

  @override
  State<Menubtn> createState() => _MenubtnState();
}

class _MenubtnState extends State<Menubtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.navigateTo.isNotEmpty) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: _getNavigateToScreen(widget.navigateTo), 
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 300),
                  ),
                );
              }
            },
            child: Container(
              height: 40,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.svgIcon.icon, 
                      size: 25,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        if (widget.description.isNotEmpty) 
                          Text(
                            widget.description,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNavigateToScreen(String navigateTo) {
    switch (navigateTo) {
      case 'Listening':
        return Listening();
      case 'Settings':
        return Settings();
      case 'New':
        return new_music();
      default:
        return Container();
    }
  }

}
