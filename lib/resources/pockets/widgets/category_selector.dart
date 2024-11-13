import 'package:flutter/material.dart';

import '../../schema.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {},
            child: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: primary_color,
                borderRadius: BorderRadius.circular(2)
              ),
              child: Center(
                child: Text(
                  'Music',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400
                  ),
                )
              )
            )
          )
        )
      ) 
    );
  }
}