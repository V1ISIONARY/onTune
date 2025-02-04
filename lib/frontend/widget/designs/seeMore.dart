import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LimitedText extends StatelessWidget {
  final String text;
  final int limit;
  final VoidCallback onSeeMore;

  const LimitedText({
    Key? key,
    required this.text,
    this.limit = 20,
    required this.onSeeMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLong = text.length > limit;
    String displayText = isLong ? "${text.substring(0, limit)}..." : text;

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 10, color: Colors.white54),
        children: [
          TextSpan(text: displayText),
          if (isLong)
            TextSpan(
              text: " See more",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              recognizer: TapGestureRecognizer()..onTap = onSeeMore,
            ),
        ],
      ),
    );
  }
}
