import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../environment/env.dart';

class Themes {
  static final baseTheme = ThemeData(
    // scaffoldBackgroundColor: Env.colors.background,
    accentColor: Env.colors.accentColor,
    textTheme: GoogleFonts.nunitoSansTextTheme(),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        ),
      ),
    ),
  );
}
