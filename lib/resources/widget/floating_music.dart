import 'package:flutter/material.dart';
import 'package:ontune/frontend/player.dart';
import 'package:ontune/resources/schema.dart';
import '../../frontend/home.dart';

class FloatingMusic extends StatefulWidget {
  final String initialAudioUrl;
  const FloatingMusic({Key? key, required this.initialAudioUrl}) : super(key: key);

  @override
  FloatingMusicState createState() => FloatingMusicState();
}

class FloatingMusicState extends State<FloatingMusic> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _controller;
  bool _isFullScreen = false;
  bool _isVisible = false;
  int _currentIndex = 0;
  
  late ValueNotifier<String> updatedWriter;
  late ValueNotifier<String> updatedTitle;
  late ValueNotifier<String> updatedUrl;
  late ValueNotifier<String> updatedIcon;
  String currentUrl = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    updatedWriter = Home.updatedWriter;
    updatedTitle = Home.updatedTitle;
    updatedUrl = Home.updatedUrl;
    updatedIcon = Home.updatedIcon;
    currentUrl = widget.initialAudioUrl;

    updatedUrl.addListener(updateInfo);

    print("Initial URL: $currentUrl");
  }

  List<Widget> get _pages {
    return [
      _buildPage(updatedIcon.value, updatedTitle.value, updatedWriter.value),
      _buildPage(updatedIcon.value, updatedTitle.value, updatedWriter.value),
    ];
  }

  @override
  void dispose() {
    updatedUrl.removeListener(updateInfo);
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void updateInfo() {
    if (mounted) {
      setState(() {
        currentUrl = updatedUrl.value;
      });
      print("Updated URL: $currentUrl");
    }
  }

  static Widget _buildPage(String thumbnail, String title, String artist) {
    return Container(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: ClipRRect(
                child: Image.network(
                  thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    artist,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w400, color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void toggleContainer() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _toggleFullScreen(bool isFullScreen) {
    setState(() {
      _isFullScreen = isFullScreen;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy < 0) {
      print("YouTube URL: ${widget.initialAudioUrl}");

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 1.0,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return Player(
              youtubeUrl: updatedUrl.value,
              thumbnail: updatedIcon.value,
              backgroundColor: Color.fromARGB(255, 2, 149, 85),
              textColor: Colors.white,
              onClose: () {
                setState(() {
                  _isVisible = false;
                });
                Navigator.of(context).pop();
              },
            );
          },
        ),
      );
    } else {
      setState(() {
        _isVisible = false;
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      if (_currentIndex > 0) _currentIndex--;
    } else if (details.velocity.pixelsPerSecond.dx < 0) {
      if (_currentIndex < _pages.length - 1) _currentIndex++;
    }
    _pageController.jumpToPage(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: _onVerticalDragEnd,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: _isFullScreen ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isVisible ? 70 : 0,
              curve: Curves.easeInOut,
              child: Visibility(
                visible: _isVisible,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: widgetPricolor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _pages.length,
                            itemBuilder: (context, index) => _pages[index],
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.connected_tv_sharp, color: Colors.white),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.play_arrow, color: Colors.white),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}