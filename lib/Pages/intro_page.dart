import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_vision/style.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kColorYellowGreen,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Name
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              child: Text(
                "Plant Vision",
                style: GoogleFonts.merriweather(
                  fontSize: screenWidth * 0.12, // Responsive font size
                  color: kColorLavenderBlush,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Icon
          Container(
            width: screenWidth * 0.6, // Responsive image width
            height: screenWidth * 0.6, // Responsive image height
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            child: Image.asset(
              'images/plant.png',
              fit: BoxFit.cover,
            ),
            alignment: Alignment.center,
          ),
          // Title
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth* 0.1),
            child: Text(
              'KNOW YOUR PLANT TROUBLE',
              style: GoogleFonts.merriweather(
                fontSize: screenWidth * 0.08, // Responsive font size
                color: kColorLavenderBlush,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Text(
              'Detect and know about plant diseases with AI. Chat with our plantbot in two languages. We care for your plant for you.',
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Responsive font size
                color: kLicorice,
                height: 1.5, // Adjust line height for better readability
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // Get Started Button
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.08),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/homepage');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kColorLavenderBlush.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03), // Responsive padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started!',
                        style: TextStyle(
                        color: kLicorice,
                        fontSize: screenWidth * 0.05, // Responsive font size
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: screenWidth * 0.07, // Responsive icon size
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
