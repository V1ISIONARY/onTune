import 'package:flutter/material.dart';
import '../../../backend/services/model/randomized.dart';

class NewReleasedSongs extends StatelessWidget {
  final List<Randomized> songs;

  const NewReleasedSongs({Key? key, required this.songs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    'New Released Songs',
                    style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                  )
                ),
              ],
            ),
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            color: Colors.white54,
            height: 1,
            width: double.infinity,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: Container(
                height: 40,
                width: double.infinity,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2)
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 1),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                  'APT',
                                    style: TextStyle(color: Colors.white, fontSize: 13.0)
                                  ),
                                  Text(
                                    'ROSE, Bruno Mars',
                                    style: TextStyle(color: Colors.white54, fontSize: 8.0)
                                  )
                                ],
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '2:00',
                          style: TextStyle(color: Colors.white54, fontSize: 10.0)
                        )
                      ) 
                    )
                  ]
                )
              )
            );
          },
        ),
        Container(
          height: 40,
          width: double.infinity,
          child: InkWell(
            onTap: () {},
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 12,
                      bottom: 12,
                      child: Text(
                        'See more',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      )
                    ),
                    Positioned(
                      right: 0,
                      top: 12,
                      bottom: 12,
                      child: Icon(
                        size: 15,
                        color: Colors.white,
                        Icons.arrow_forward_ios
                      )
                    )
                  ]
                )
              )
            )
          )
        ),
      ],
    );
  }
}