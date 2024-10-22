// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ontune/resources/schema.dart';
import 'package:page_transition/page_transition.dart';

import '../resources/widget/main_navigation.dart';

class Search extends StatefulWidget {
  final bool enableReturn; 

  const Search({
    super.key, 
    required this.enableReturn,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late FocusNode _focusNode;

  final List<String> hints = [
    'Cotton Candy - Arthur Nery',
    'Blinding Lights - The Weeknd',
    'Shape of You - Ed Sheeran',
    'Levitating - Dua Lipa',
    'Stay - The Kid LAROI & Justin Bieber',
  ];

  int _currentHintIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    _focusNode = FocusNode();

    // Start hint text change every 2 seconds
    _changeHintText();

    // Add listener to focus node
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Hide hint text when focused
        _controller.forward();
      } else {
        // Show hint text when not focused
        _controller.reverse();
      }
    });
  }

  void _changeHintText() {
    Future.delayed(Duration(seconds: 2), () {
      if (!_focusNode.hasFocus) { // Only change hint if not focused
        _controller.forward().then((_) {
          setState(() {
            _currentHintIndex = (_currentHintIndex + 1) % hints.length;
          });
          _controller.reverse().then((_) {
            _changeHintText(); // Recursively call to change hints
          });
        });
      } else {
        _changeHintText(); // Call again to maintain the hint change cycle
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    _focusNode.dispose(); // Dispose of the focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.enableReturn) ...[
                Container(
                  height: 50,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const MainWrapper(initialPage: 0),
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 200),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 17,
                            color: Colors.white,
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(
                child: Container(
                  height: 50,
                  child: Center(
                    child: Container(
                      height: 30,
                      child: Stack(
                        children: [
                          // TextField for input
                          TextField(
                            focusNode: _focusNode,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              hintText: '', // No hint text in TextField
                              hintStyle: TextStyle(
                                color: Colors.transparent, // Hide hint text in field
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0), // Padding adjustment
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          // Hint text sliding up
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0), // Start position
                              end: Offset(0, -1), // Slide up position
                            ).animate(_controller),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 6), // Padding to align with TextField
                              child: InkWell(
                                onTap: (){
                                  focusNode: _focusNode;
                                },
                                child: Text(
                                  hints[_currentHintIndex],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.3), // Adjust color for visibility
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: List.generate(2, (index) {
              return Column(
                children: [
                  InkWell(
                    onTap:(){},
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
                                // Container(
                                //   child: Center(
                                //     child: Text(
                                //       '1',
                                //       style: TextStyle(
                                //         fontSize: 17,
                                //         color: Colors.white54,
                                //         fontWeight: FontWeight.w300
                                //       ),
                                //     ),
                                //   )
                                // ),
                                // SizedBox(width: 40),
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
                    ),
                  ),
                  Container(
                    color: Colors.white10,
                    height: 1,
                    width: double.infinity,
                  ),
                ]
              );
            }),
          ),
          ElevatedButton(
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Rounded corners
              ),
            ),
            child: Container(
              height: 40,
              // margin: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'See more',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              )
            )
          ),
          Container(
            height: 30,
            width: double.infinity,
            color: Colors.white10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  'Search Suggestions',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate how many rows are needed based on item count and crossAxisCount
                  int crossAxisCount = 2;
                  int rowCount = (10 / crossAxisCount).ceil(); // Adjust for your item count
                  // Calculate total height: (item height + spacing) * number of rows
                  double itemHeight = 190;
                  double spacing = 12;
                  double totalHeight = (itemHeight * rowCount) + (spacing * (rowCount - 1));
                  return SizedBox(
                    height: totalHeight, // Adjust the height as needed
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10, // Minimized vertical spacing
                        crossAxisSpacing: 10, // Minimized horizontal spacing
                        childAspectRatio: 140 / 125 // Keep as needed
                      ),
                      itemCount: 11, // Set item count as required
                      shrinkWrap: true, 
                      physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling if needed
                      padding: const EdgeInsets.symmetric(horizontal: 20), // Reduce overall padding around the grid
                      itemBuilder: (_, index) => GridTile(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: primary_color, // Replace with your desired color
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4), // Adjust vertical spacing within the item
                              Container(
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Happier Than Ever',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 2), // Adjust spacing between texts
                                        Text(
                                          'Billie Eilish',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 5,
                                      child: Container(
                                        height: 30,
                                        child: Center(
                                          child: Icon(
                                            size: 15,
                                            color: Colors.white,
                                            Icons.headset_rounded
                                          )
                                        ),
                                      )
                                    )
                                  ]
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 20),
            ],
          )
        ]
      ),
    );
  }
}