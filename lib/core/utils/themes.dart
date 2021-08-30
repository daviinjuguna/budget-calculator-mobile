import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kGreen = const Color(0xff0dd79d);
const kDarkGreen = const Color(0xff048a64);
const kLightGreen = const Color(0xff29FFC2);
const kMaroonColor = const Color(0xff8A1F00);

final defaultColorScheme = ColorScheme.light(
  primary: kGreen,
  primaryVariant: kDarkGreen,
  secondary: kLightGreen,
  secondaryVariant: kDarkGreen,
  error: kMaroonColor,
);
final defaultTextTheme = GoogleFonts.robotoTextTheme();
