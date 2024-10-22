import 'package:flutter/material.dart';

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
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    artist,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100, color: Colors.white),
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
      // Swipe up: Show full-screen page
      _toggleFullScreen(true);
    } else if (details.velocity.pixelsPerSecond.dy > 0) {
      // Swipe down: Close full-screen page if open
      if (_isFullScreen) {
        _toggleFullScreen(false);
      }
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
          
          // Full-screen overlay container
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: const Color.fromARGB(255, 2, 149, 85),
            width: double.infinity,
            height: _isFullScreen ? 500 : 0,
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      // Positioned InkWell Icon
                      Positioned(
                        left: 10,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isFullScreen = false;
                            });
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.white,
                )
              ],
            ),
          ),


          // Mini music player container
          AnimatedOpacity(
            opacity: _isFullScreen ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isVisible ? 85 : 0,
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
                    margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 0),
                    child: Row(
                      children: [
                        // Album artwork
                        Container(
                          height: 40,
                          width: 40,
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
                          width: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.connected_tv_sharp, color: Colors.white),
                                onPressed: () {},
                              ),
                              IconButton(
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
