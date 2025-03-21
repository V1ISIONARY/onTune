import 'package:flutter/material.dart';
import 'package:ontune/frontend/pages/home.dart';
import 'package:ontune/frontend/widget/floating_music.dart';
import '../../../backend/services/model/randomized.dart';

class SearchSection extends StatelessWidget {
  final Randomized song;
  final VoidCallback onToggle;
  final GlobalKey<FloatingMusicState> floatingMusicKey;

  const SearchSection({
    Key? key,
    required this.song,
    required this.onToggle,
    required this.floatingMusicKey
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onToggle.call();
        Home.updatedUrl.value = song.audioUrl;
        Home.updatedTitle.value = song.musicTitle;
        Home.updatedWriter.value = song.musicWriter;
        Home.updatedIcon.value = song.thumnail;
      },
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 15.5 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blue,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    song.thumnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.white, size: 40),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.musicTitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.musicWriter,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
