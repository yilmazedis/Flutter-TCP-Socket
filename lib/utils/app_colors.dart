import 'package:flutter/material.dart';

const LinearGradient metallicGradient = LinearGradient(
  colors: [
    Color(0xFFBFBFBF), // Light gray
    Color(0xFF6E6E6E), // Dark gray
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Define your metallic colors
const Color metallicLightColor = Color(0xFFBFBFBF); // Light gray
const Color metallicDarkColor = Color(0xFF6E6E6E); // Dark gray
const MaterialColor metallicPrimaryColor = MaterialColor(
  0xFFBFBFBF, // Light gray
  <int, Color>{
    50: Color(0xFFBFBFBF),
    100: Color(0xFFBFBFBF),
    200: Color(0xFFBFBFBF),
    300: Color(0xFFBFBFBF),
    400: Color(0xFFBFBFBF),
    500: Color(0xFFBFBFBF),
    600: Color(0xFFBFBFBF),
    700: Color(0xFFBFBFBF),
    800: Color(0xFFBFBFBF),
    900: Color(0xFFBFBFBF),
  },
);