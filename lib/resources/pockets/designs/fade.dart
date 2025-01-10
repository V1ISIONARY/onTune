import 'dart:ui';
import 'package:flutter/material.dart';

class WhiteBackgroundPainter extends CustomPainter {

  final double height; 
  final Alignment begin;
  final Alignment end;

  WhiteBackgroundPainter({
    required this.height,
    required this.begin,
    required this.end
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: begin,
        end: end,
        //default
        // begin: Alignment.topLeft,
        // end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(0, 0, 0, 0),
          Color.fromARGB(170, 24, 24, 24),
          const Color.fromARGB(255, 0, 0, 0),
        ],
        stops: [0.2, 0.5, 1.0],
      ).createShader(
          Rect.fromLTWH(0, size.height * height, size.height * 0, size.width));

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
  
}