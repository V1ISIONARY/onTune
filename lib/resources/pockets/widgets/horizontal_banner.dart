import 'package:flutter/material.dart';

import '../../schema.dart';

class HorizontalBanner extends StatelessWidget {
  const HorizontalBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              // Your banner content here
            ],
          ),
        ),
      ),
    );
  }
}