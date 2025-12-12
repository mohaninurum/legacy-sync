import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:pull_down_button/pull_down_button.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.dmSans(color: AppColors.whiteColor, fontSize: 14),
      bodySmall: GoogleFonts.dmSans(color: AppColors.whiteColor),
      bodyLarge: GoogleFonts.dmSerifDisplay(
        color: AppColors.whiteColor,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.dmSans(color: Colors.white, fontSize: 14),
      bodySmall: GoogleFonts.dmSans(color: Colors.white),
      bodyLarge: GoogleFonts.dmSerifDisplay(
        color: AppColors.whiteColor,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
    ),
    extensions:  [
      PullDownButtonTheme(
        routeTheme: const PullDownMenuRouteTheme(
          accessibilityWidth: 200,
          width: 200,
          backgroundColor: Color(0xFFF0F0F0),
        ),
        itemTheme:const PullDownMenuItemTheme(
          destructiveColor: Colors.red,
          iconActionTextStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.normal,fontSize: 16),
          textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 16),
          subtitleStyle: TextStyle(color: Colors.black),
        ),
        dividerTheme: PullDownMenuDividerTheme(
          dividerColor: Colors.grey.shade700,
        ),
        titleTheme:const PullDownMenuTitleTheme(style: TextStyle(color: Colors.black))
      ),
    ]
  );
}
