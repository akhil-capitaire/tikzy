import 'package:flutter/widgets.dart';

class ScreenSize {
  // Initialize screen dimensions and scaling factors
  static double? screenWidth;
  static double? screenHeight;
  static double? textScaleFactor;
  static double? scaleFactor;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  // Call this function in the main function or at the start of your app to initialize values
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Define scaling factor (base screen width for scaling)
    scaleFactor = screenWidth! / 375.0; // 375 is the base width (you can adjust this)

    // Calculate block size horizontal and vertical
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
  }

  // Function to scale general values (e.g., padding, margin)
  static double scale(double value) {
    return value * scaleFactor!;
  }

  // Function to scale text size based on screen width and text scale factor
  static double fontSize(double value) {
    // Scale text based on screen width and text scale factor
    return value * scaleFactor! * textScaleFactor!;
  }

  // Function to get horizontal block size (for responsive UI)
  static double width(double value) {
    return value * blockSizeHorizontal!;
  }

  // Function to get vertical block size (for responsive UI)
  static double height(double value) {
    return value * blockSizeVertical!;
  }

  // Function to scale radius for rounded corners, etc.
  static double radius(double value) {
    return value * scaleFactor!;
  }
}
