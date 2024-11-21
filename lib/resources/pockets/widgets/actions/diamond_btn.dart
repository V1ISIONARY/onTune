// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiamondBtn extends StatelessWidget {
  
  final String svgPath;
  final String text;
  final String actionPath;

  const DiamondBtn({
    super.key,
    required this.svgPath,
    required this.text,
    required this.actionPath
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgPath,
                height: 15,
              ),
              SizedBox(width: 10),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black38,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}