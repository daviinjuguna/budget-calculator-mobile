import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sortika_budget_calculator/core/utils/hex_converter.dart';

const kGreen = const Color(0xff0dd79d);
const kDarkGreen = const Color(0xff048a64);
const kLightGreen = const Color(0xff29FFC2);
const kMaroonColor = const Color(0xff8A1F00);
const kPurpleColor = const Color(0xff78519E);

final defaultColorScheme = ColorScheme.light(
  primary: kGreen,
  primaryVariant: kDarkGreen,
  secondary: kLightGreen,
  secondaryVariant: kDarkGreen,
  error: Colors.red,
);
final defaultTextTheme = GoogleFonts.robotoTextTheme();

final kCardGradient = LinearGradient(colors: [
  HexColor("#FAF2FF"),
  HexColor("#F5E7FF"),
  HexColor("#EBE2FD"),
  HexColor("#E3D8FF"),
  HexColor("#E2D8FD")
]);
