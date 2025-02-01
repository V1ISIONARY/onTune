// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ontune/resources/pockets/widgets/actions/diamond_btn.dart';
import 'package:ontune/resources/schema.dart';

import '../../resources/pockets/designs/fade.dart';

class diamond extends StatelessWidget {
  const diamond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://i.pinimg.com/736x/c3/4f/ed/c34feddd03e50ef52e800405971526f0.jpg'
            ), // Path to your image
            fit: BoxFit.cover, // Adjusts how the image fits the container
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              painter: WhiteBackgroundPainter(height: 0.5, begin: Alignment.topLeft, end: Alignment.bottomRight),
              child: Container(),
            ),
            Positioned(
              bottom: 30,
              right: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign in and enjoy \nmillions of songs at no cost.',
                          style: GoogleFonts.notoSans(
                            textStyle: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold)
                          )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 10),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Expanded(
                        //         child: InkWell(
                        //           onTap: () {},
                        //           child: Container(
                        //             height: 60,
                        //             width: double.infinity,
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(10),
                        //               color: Colors.transparent, // Make background transparent
                        //               border: Border.all( // Add stroke
                        //                 color: Colors.white, // Stroke color
                        //                 width: 2, // Adjust stroke width
                        //               ),
                        //             ),
                        //             child: Center(
                        //               child: Text(
                        //                 "Create new account",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                   fontSize: 13,
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(width: 10),
                        //       Expanded(
                        //         child: InkWell(
                        //           onTap: () {},
                        //           child: Container(
                        //             height: 60,
                        //             width: double.infinity,
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(10),
                        //               color: Colors.transparent, // Make background transparent
                        //               border: Border.all( // Add stroke
                        //                 color: Colors.white, // Stroke color
                        //                 width: 2, // Adjust stroke width
                        //               ),
                        //             ),
                        //             child: Center(
                        //               child: Text(
                        //                 "Login",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                   fontSize: 13,
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   )
                        // ),
                        DiamondBtn(
                          svgPath: 'lib/resources/svg/apple.svg', 
                          text: 'Continue with apple', 
                          actionPath: ''
                        ),
                        SizedBox(height: 10),
                        DiamondBtn(
                          svgPath: 'lib/resources/svg/google.svg', 
                          text: 'Continue with google', 
                          actionPath: ''
                        ),
                        SizedBox(height: 10),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 50,
                        //     width: double.infinity,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: Colors.transparent, // Make background transparent
                        //       border: Border.all( // Add stroke
                        //         color: Colors.white, // Stroke color
                        //         width: 2, // Adjust stroke width
                        //       ),
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         "Create new account",
                        //         textAlign: TextAlign.center,
                        //         style: TextStyle(
                        //           fontSize: 11,
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.w400,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            width: double.infinity,
                            height: 0.5,
                            color: widgetSeccolor,
                          )
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'By signing up, you confirm that you agree to our ',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white54,
                              fontWeight: FontWeight.w400,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: Colors.white, // Black text color
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' and have read and understood our ',
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.white, // Black text color
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '.',
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ]
              )
            )
          ]
        ),
      ),
    );
  }
}