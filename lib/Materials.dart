import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData themeData() {
  return ThemeData(
    backgroundColor: Color(0xFFFFFFFF),
    primaryColor: Color(0xFFFFFFFF),
    appBarTheme: AppBarTheme(
      color: Color(0xFFFB5B7B),
    ),
    cardColor: Color(0xFFF9ED4E),
    scaffoldBackgroundColor: Color(0xFFF9F9F9),
    canvasColor: Color(0xFFE8715F),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      // secondary: Color(0xFF73F8FC),
      secondary: Color(0xFFF9ED4E),
    ),
  );
}

TextStyle lobster2TextStyle({
  double? fontSize,
  double? letterSpacing,
  Color? color,
  TextDecoration? textDecoration,
  bool enableShadow = false,
  FontWeight? fontWeight,
}) {
  return GoogleFonts.lobsterTwo(
    fontSize: fontSize == null ? 22.sp : fontSize.sp,
    color: color ?? Colors.black87,
    decoration: textDecoration,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing ?? 1.0,
    shadows: enableShadow
        ? [
            Shadow(
                offset: Offset(0, 4.5), blurRadius: 4, color: Colors.black38),
          ]
        : null,
  );
}

TextStyle poppinsTextStyle({
  double? fontSize,
  double? letterSpacing,
  Color? color,
  TextDecoration? textDecoration,
  bool enableShadow = false,
  FontWeight? fontWeight,
}) {
  return GoogleFonts.poppins(
    fontSize: fontSize == null ? 22.sp : fontSize.sp,
    color: color ?? Colors.black87,
    decoration: textDecoration,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing ?? .5,
    shadows: enableShadow
        ? [
            Shadow(
                offset: Offset(0, 4.5), blurRadius: 4, color: Colors.black38),
          ]
        : null,
  );
}

TextStyle pacificoTextStyle({
  double? fontSize,
  double? letterSpacing,
  Color? color,
  TextDecoration? textDecoration,
  bool enableShadow = false,
  FontWeight? fontWeight,
}) {
  return GoogleFonts.pacifico(
    fontSize: fontSize == null ? 22.sp : fontSize.sp,
    color: color ?? Colors.black87,
    decoration: textDecoration,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    shadows: enableShadow
        ? [
            Shadow(
                offset: Offset(0, 4.5), blurRadius: 4, color: Colors.black38),
          ]
        : null,
  );
}

class MyColorScheme {
  static Color englishVermillion = Color(0xFFC83F49);
  static Color brinkPink = Color(0xFFFB5B7B);
  static Color corn = Color(0xFFF9ED4E);
  static Color aqua = Color(0xFF3BF4FB);
  static Color terraCotta = Color(0xFFE8715E);
  static Color mauvelous = Color(0xFFEC98A8);
}
