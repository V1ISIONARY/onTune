import 'package:flutter/material.dart';
import 'package:ontune/frontend/pages/home.dart';
import 'package:ontune/frontend/widget/floating_music.dart';
import '../../../backend/services/model/randomized.dart';

class LongSingle extends StatelessWidget {

  final Randomized? song;
  final VoidCallback? onToggle;
  final GlobalKey<FloatingMusicState>? floatingMusicKey;

  const LongSingle({
    Key? key,
    required this.song,
    this.onToggle,
    this.floatingMusicKey
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap:(){
            onToggle?.call();
            Home.updatedUrl.value = song!.audioUrl;
            Home.updatedTitle.value = song!.musicTitle;
            Home.updatedWriter.value = song!.musicWriter;
            Home.updatedIcon.value = song!.thumnail;
          },
          child: Container(
            height: 40,
            width: double.infinity, // Fixed width for each container
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.network(
                            song!.thumnail,
                            fit: BoxFit.cover,
                          ),
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
                              song!.musicTitle,
                                style: TextStyle(color: Colors.white, fontSize: 13.0)
                              ),
                              Text(
                                song!.musicWriter,
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
          ),
        ),
        Container(
          color: Colors.white10,
          height: 1,
          width: double.infinity,
        ),
      ],
    );
  }
}