// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ontune/resources/schema.dart';
import 'package:page_transition/page_transition.dart';

import '../backend/bloc/on_tune_bloc.dart';
import '../backend/services/model/randomized.dart';
import '../resources/pockets/main_navigation.dart';
import '../resources/pockets/widgets/long_single.dart';
import '../resources/pockets/widgets/search_section.dart';

class Search extends StatefulWidget {
  final bool enableReturn; 

  const Search({
    super.key, 
    required this.enableReturn,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<Offset> _hintAnimation;
  late Animation<Color?> _hintColorAnimation;
  late FocusNode _focusNode;
  late AnimationController _controllerFade;
  late Animation<Color?> _colorAnimation;
  late TextEditingController _textEditingController;
  bool _isFadedOut = false;

  late AnimationController _controllerArtist; // Animation for container movement
  late Animation<double> _positionAnimation1;
  late Animation<double> _positionAnimation2;
  double position1 = 300; // Initial position for the first container (right side)
  double position2 = 300; // Initial position for the second container (right side)

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

    // Initialize controllers
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _controllerFade = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Initialize the animation controller
    _controllerArtist = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Define the animations for both containers
    _positionAnimation1 = Tween<double>(begin: 400, end: -200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _positionAnimation2 = Tween<double>(begin: 600, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Start the animation loop
    _controllerArtist.repeat();

    // Set up animations
    _hintAnimation = Tween<Offset>(
      begin: Offset(0, 0), // Start position
      end: Offset(0, -1), // Slide up position
    ).animate(_controller);

    _hintColorAnimation = ColorTween(
      begin: Colors.white.withOpacity(0.5), // Start with transparent
      end: const Color.fromARGB(0, 148, 37, 37), // End with desired color and opacity
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: Colors.white70, // Start with white color
      end: Colors.transparent, // Fade to transparent
    ).animate(_controllerFade);

    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _changeHintText();

    // Add listener to focus node
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controllerFade.forward();
        _controller.forward();
      } else if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controller.reverse();
        _controllerFade.reverse();
      }
    });
  }

  void _toggleTextVisibility() {
    if (_isFadedOut) {
      _controllerFade.reverse();
    } else {
      _controllerFade.forward();
    }

    setState(() {
      _isFadedOut = !_isFadedOut;
    });
  }

  void _changeHintText() {
    Future.delayed(Duration(seconds: 2), () {
      if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controller.forward().then((_) {
          setState(() {
            _currentHintIndex = (_currentHintIndex + 1) % hints.length;
          });
          _controller.reverse().then((_) {
            _changeHintText(); // Recursively call to change hints
          });
        });
      } else {
        _changeHintText(); // Continue changing hints even if focus is lost
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerFade.dispose();
    _controllerArtist.dispose(); // Added semicolon here
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.enableReturn) ...[
                Container(
                  height: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const MainWrapper(initialPage: 0),
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 300),
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
                          // TextField for input
                        Positioned.fill(
                          child: TextField(
                            controller: _textEditingController,
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
                        ),
                        // Hint text sliding up inside the TextField's border
                        Positioned(
                          top: 6,
                          left: 12, // Padding for hint text alignment
                          right: 12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  FocusScope.of(context).requestFocus(_focusNode);
                                }, // Handle the click
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: AnimatedBuilder(
                                    animation: _controllerFade, // Listen to the animation controller
                                    builder: (context, child) {
                                      return Text(
                                        "Search for",
                                        style: TextStyle(
                                          color: _colorAnimation.value, // Change color during animation
                                          fontSize: 13,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SlideTransition(
                                position: _hintAnimation,
                                child: AnimatedBuilder(
                                  animation: _hintColorAnimation,
                                  builder: (context, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).requestFocus(_focusNode);
                                      },
                                      child: Text(
                                        hints[_currentHintIndex],
                                        style: TextStyle(
                                          color: _hintColorAnimation.value, // Color changes during animation
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: GestureDetector(
                  onTap: () {},
                  child: Transform.translate(
                    offset: Offset(3, 0), // Move 5 units to the left (negative x-direction)
                    child: Container(
                      height: 50,
                      width: 40,
                      child: Center(
                        child: SvgPicture.asset(
                          'lib/resources/svg/melody.svg',
                          color: Colors.white,
                          height: 22,
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: BlocConsumer<OnTuneBloc, OnTuneState>(
        listener: (context, state) {
          if (state is FetchExplorer) {
            print("Fetched explorer liste: ${state.explorerList.length}");
          }
        },
        builder: (context, state) {
          if (state is LoadingTune) {
            context.read<OnTuneBloc>().add(LoadTune());
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchExplorer) {

            final List<Randomized> songs = state.explorerList;
            List<dynamic> double_single = songs.take(20).toList();
            List<dynamic> long_single = songs.skip(10).take(3).toList();

            return ListView(
              children: [
                for (var single in long_single)
                  LongSingle(song: single),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
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
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Container(
                //       margin: const EdgeInsets.all(20),
                //       child: Text(
                //         'Our Artist',
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 13,
                //         ),
                //       ),
                //     ),
                //     Container(
                //       width: double.infinity,
                //       height: 80,
                //       child: Stack(
                //         children: [
                //           AnimatedBuilder(
                //             animation: _positionAnimation1,
                //             builder: (context, child) {
                //               return AnimatedPositioned(
                //                 duration: Duration(seconds: 1), // No animation duration, it’s controlled by the controller
                //                 left: _positionAnimation1.value, // Use the animation value for the position
                //                 top: 0,
                //                 child: Container(
                //                   height: 35,
                //                   width: 150,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(20),
                //                     color: Colors.blue,
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
                //           AnimatedBuilder(
                //             animation: _positionAnimation2,
                //             builder: (context, child) {
                //               return AnimatedPositioned(
                //                 duration: Duration(seconds: 1), // No animation duration, it’s controlled by the controller
                //                 left: _positionAnimation2.value, // Use the animation value for the position
                //                 top: 45,
                //                 child: Container(
                //                   height: 35,
                //                   width: 150,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(20),
                //                     color: Colors.red,
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
                //         ],
                //       ),
                //     )
                //   ],
                // ),                                  
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10, // Minimized vertical spacing
                                  crossAxisSpacing: 10, // Minimized horizontal spacing
                                  childAspectRatio: 145 / 110 // Keep as needed
                                ),
                                itemCount: 20, // Set item count as required
                                shrinkWrap: true, 
                                physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling if needed
                                padding: const EdgeInsets.symmetric(horizontal: 20), // Reduce overall padding around the grid
                                itemBuilder: (_, index) => GridTile(
                                  child: SearchSection(
                                    song: double_single[index], 
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'onTune',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  'Hello World Negah',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white30
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ]
                    ),
                  ],
                )
              ]
            );
          } else if (state is ErrorTune) {
            return Center(
              child: Text(
                "Error: ${state.response}",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return const SizedBox.shrink();
          
        }
      )
    );
  }
}