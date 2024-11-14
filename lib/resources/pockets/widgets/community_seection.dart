import 'package:flutter/material.dart';
import '../../../backend/services/model/randomized.dart';
import 'actions/multiple_music.dart';

class CommunitySection extends StatelessWidget {
  final List<Randomized> songs;

  const CommunitySection({Key? key, required this.songs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20, left: 20),
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    'From the community',
                    style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)
                  )
                ),
                Positioned(
                  right: 20,
                  top: 2,
                  bottom: 2,
                  child: InkWell(
                    onTap: () {},
                    child: Text('View all >',
                      style: TextStyle(color: Colors.white38, fontSize: 10.0)
                    )
                  )
                )
              ],
            ),
          )
        ),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 10),
                child: multiple_music_action(
                  combineImages: "https://ourculturemag.com/wp-content/uploads/2021/11/Artwork_SilkSonic-scaled.jpeg",
                  playlistLink: "playlistLink",
                  userImage: "https://scontent.fcrk1-4.fna.fbcdn.net/v/t39.30808-6/460292731_2314205352293218_6527050771950301280_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGvq3BXlK0UDYpVBtPCO5CIMnbb7VtcaV0ydtvtW1xpXbr90X4IiuLmhtJPB8-n9bBbBURlpN_hdsCzvy_X9PAP&_nc_ohc=1ZO8THliQd8Q7kNvgF7zaeo&_nc_zt=23&_nc_ht=scontent.fcrk1-4.fna&_nc_gid=ASIj4Jch6IM3gC9kTSQCvoa&oh=00_AYBbgIkDrivQh46tCq0GLeDnRyu0xoeAgQcRUBrdkmleqQ&oe=673A0CC9",
                  username: "Yknila",
                  title: "Playlist that transition perfectly",
                  viewers: "23",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}