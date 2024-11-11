import 'package:flutter/material.dart';
import 'package:ontune/frontend/player.dart';
import 'package:page_transition/page_transition.dart';

class FloatingMusic extends StatefulWidget {
  const FloatingMusic({Key? key}) : super(key: key);

  @override
  FloatingMusicState createState() => FloatingMusicState();
}

class FloatingMusicState extends State<FloatingMusic> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false; // Controls visibility of the mini container
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool _isFullScreen = false; // Track if full-screen is active

  final List<Widget> _pages = [
    _buildPage('WILDFLOWER', 'Billie Eilish'),
    _buildPage('Birds of feather', 'Billie Eilish'),
  ];

  // Define the pages to display
  static Widget _buildPage(String title, String artist) {
    return Container(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Toggle mini container visibility
  void toggleContainer() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  // Handle full-screen state toggle
  void _toggleFullScreen(bool isFullScreen) {
    setState(() {
      _isFullScreen = isFullScreen;
    });
  }

  // Handle vertical swipe gesture
  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy < 0) {
      // Swipe up to show player screen as a full-screen modal overlay
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 1.0, // Start fully expanded
          minChildSize: 1.0,     // Prevent dragging down to minimize
          maxChildSize: 1.0,     // Make it cover the full screen
          builder: (context, scrollController) {
            return Player(
              youtubeUrl: 'https://music.youtube.com/watch?v=bl2DzNG-haU',
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
      // Swipe down to close mini container
      setState(() {
        _isVisible = false;
      });

    }
  }

  // Handle horizontal swipe gesture
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
          // Mini music player container
          AnimatedOpacity(
            opacity: _isFullScreen ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isVisible ? 80 : 0,
              curve: Curves.easeInOut,
              child: Visibility(
                visible: _isVisible,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 2, 149, 85),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
                    child: Row(
                      children: [
                        // Album artwork
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                        ),
                        // PageView for songs
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
                        // Control icons
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                iconSize: 23,
                                icon: const Icon(Icons.connected_tv_sharp, color: Colors.white),
                                onPressed: () {},
                              ),
                              IconButton(
                                iconSize: 23,
                                icon: const Icon(Icons.play_arrow, color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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