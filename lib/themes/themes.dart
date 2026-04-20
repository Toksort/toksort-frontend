import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

Color iconColor = const Color(0xff60A5FA);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

enum EnumFontFamily { montserrat, poppins }
enum EnumFontStyle { normal, italic }

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,

    primaryColor: const Color(0xff5B9CFF),
    scaffoldBackgroundColor: const Color(0xffF5F6F8),
    disabledColor: const Color(0xffC4C4C4),

    colorScheme: const ColorScheme.light(
      primary: Color(0xff5B9CFF),
      surface: Colors.white,
      onSurface: Color(0xff1C1C1E),
      error: Color(0xffE93932),
    ),

    extensions: const [
      AppColors(
        card: Color(0xffF3F3F3),
        border: Color(0xffC5C5C5),
        softBlue: Color(0xffD2E6FF),
        success: Color(0xff32E948),
        error: Color(0xffE93932),
        textSecondary: Color(0xff999999),
      ),
    ],

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF5F6F8),
      foregroundColor: Color(0xff5B9CFF),
      elevation: 0,
    ),

    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      bodyMedium: const TextStyle(
        color: Color(0xff1C1C1E),
      ),
      bodySmall: TextStyle(
        color: const Color(0xff8E8E93),
        fontSize: 12,
        fontWeight: regular,
      ),
      titleLarge: TextStyle(
        color: const Color(0xff5B9CFF),
        fontSize: 22,
        fontWeight: medium,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,

    primaryColor: const Color(0xff5B9CFF),
    scaffoldBackgroundColor: const Color(0xff121212),
    disabledColor: const Color(0xff555555),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xff5B9CFF),
      surface: Color(0xff1E1E1E),
      onSurface: Color(0xffE5E5E5),
      error: Color(0xffE93932),
    ),

    extensions: const [
      AppColors(
        card: Color(0xff1E1E1E),
        border: Color(0xff444444),
        softBlue: Color(0xff1A3A5F),
        success: Color(0xff32E948),
        error: Color(0xffE93932),
        textSecondary: Color(0xff9E9E9E),
      ),
    ],

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff121212),
      foregroundColor: Color(0xff5B9CFF),
      elevation: 0,
    ),

    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      bodyMedium: const TextStyle(
        color: Color(0xffE5E5E5),
      ),
      bodySmall: TextStyle(
        color: const Color(0xff9E9E9E),
        fontSize: 12,
        fontWeight: regular,
      ),
      titleLarge: TextStyle(
        color: const Color(0xff5B9CFF),
        fontSize: 22,
        fontWeight: medium,
      ),
    ),

    iconTheme: const IconThemeData(color: Color(0xffE5E5E5)),
    cardColor: const Color(0xff1E1E1E),
  );
}

TextStyle styletext({
  required double fontsize,
  required FontWeight fontWeight,
  required BuildContext context,
  EnumFontStyle fontStyle = EnumFontStyle.normal,
  EnumFontFamily fontFamily = EnumFontFamily.poppins,
  Color? color,
  double letterSpacing = 0.0,
}) {
  final defaultColor =
      color ?? Theme.of(context).textTheme.bodyMedium?.color;

  FontStyle flutterFontStyle =
      fontStyle == EnumFontStyle.italic ? FontStyle.italic : FontStyle.normal;

  switch (fontFamily) {
    case EnumFontFamily.montserrat:
      return GoogleFonts.montserrat(
        fontSize: fontsize,
        fontWeight: fontWeight,
        fontStyle: flutterFontStyle,
        color: defaultColor,
        letterSpacing: letterSpacing,
      );
    case EnumFontFamily.poppins:
      return GoogleFonts.poppins(
        fontSize: fontsize,
        fontWeight: fontWeight,
        fontStyle: flutterFontStyle,
        color: defaultColor,
        letterSpacing: letterSpacing,
      );
  }
}