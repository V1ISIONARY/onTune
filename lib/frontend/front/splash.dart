// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:ontune/resources/schema.dart';

class splash extends StatelessWidget {
  const splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            color: widgetPricolor,
          )
        ),
      ),
    );
  }
}