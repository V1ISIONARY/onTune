import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../resources/schema.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // Corrected to height
    double indicatorContent = screenHeight * 0.1; // 70% of the screen height
    double bodyContent = screenHeight * 0.7; // 70% of the screen height

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Notification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: indicatorContent,
            height: double.infinity,
            color: primary_color,
          ),
          Expanded( // Ensures the container occupies the remaining height
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              width: bodyContent,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: primary_color,
                  borderRadius: BorderRadius.circular(5)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
