// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ontune/resources/schema.dart';

class Listening extends StatefulWidget {

  const Listening({
    super.key
  });

  @override
  State<Listening> createState() => _ListeningState();
}

class _ListeningState extends State<Listening> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Who's\nListening?",
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                textStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)
              )
            ),
            SizedBox(height: 50),
            Container(
              height: 300,
              width: 300,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Define a fixed item count
                  int itemCount = 4;
                  // Define grid layout
                  int crossAxisCount = 2; // 2 columns
                  int rowCount = (itemCount / crossAxisCount).ceil(); // Rows needed for 4 items

                  // Calculate total height based on item height and spacing
                  double itemHeight = 90; // Adjust item height
                  double spacing = 10;    // Spacing between items
                  double totalHeight = (itemHeight * rowCount) + (spacing * (rowCount - 1));

                  return SizedBox(
                    height: totalHeight,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,          // 2 items per row
                        mainAxisSpacing: 30,        // Vertical spacing
                        crossAxisSpacing: 10,       // Horizontal spacing
                        childAspectRatio: 140 / 125 // Adjust aspect ratio as needed
                      ),
                      itemCount: itemCount,         // Limit items to 4
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                      padding: const EdgeInsets.symmetric(horizontal: 10), // Reduce padding
                      itemBuilder: (_, index) => GridTile(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: (){},
                                  child: Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widgetPricolor, // Replace with your desired color
                                    )
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}