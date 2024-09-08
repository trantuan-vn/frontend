// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';

import '../appearance/app_colors.dart';

class AppTheme {
    static ThemeData buildLightMaterialTheme(VisualDensity density) => ThemeData(
        primaryColor: const Color(0xFFFFFFFF),
        primaryColorDark: const Color(0xFFFFFFFF),
        primaryColorLight: const Color(0xFFFFFFFF),
        disabledColor: AppColors.greyMedium,
        dividerColor: AppColors.divider,
        brightness: Brightness.light,
        fontFamily: GoogleFonts.roboto().fontFamily,
        primaryIconTheme: const IconThemeData(size: 24),
        textTheme: TextTheme(
          headline1: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xff383838)),
          headline2: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 16, color: const Color(0xff383838)),
          headline3: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xFF3D9FE6)),
          headline4: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xff383838)),
          headline5: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xff868686)),
          headline6: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xffFFAC0C)),
          subtitle1: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF3D9FE6)),
          subtitle2: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 13, color: const Color(0xFF3D9FE6)),
          overline: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 13, color: const Color(0xff383838)),
          button: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 13, color: const Color(0xff868686)),
          caption: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 13, color: const Color(0xffFFAC0C)),
        ),
        visualDensity: density,
    );

  
  /// Usage: AppTheme.darkTheme(child: Column(...))
  static ThemeData buildDarkMaterialTheme(VisualDensity density) => ThemeData(
        primaryColor: const Color(0xFF000000),
        primaryColorDark: const Color(0xFF000000),
        primaryColorLight: const Color(0xFF000000),
        disabledColor: AppColors.greyMedium,
        dividerColor: AppColors.divider,
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.roboto().fontFamily,
        primaryIconTheme: const IconThemeData(size: 24),
        textTheme: TextTheme(
          headline1: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 20, color: const Color(0xff383838)),
          headline2: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 16, color: const Color(0xff383838)),
          headline3: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xFF3D9FE6)),
          headline4: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xff383838)),
          headline5: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xff868686)),
          headline6: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xffFFAC0C)),
          subtitle1: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF3D9FE6)),
          subtitle2: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 13, color: const Color(0xFF3D9FE6)),
          overline: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 13, color: const Color(0xff383838)),
          button: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 13, color: const Color(0xff868686)),
          caption: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 13, color: const Color(0xffFFAC0C)),
        ),
        visualDensity: density,
  );
  static Theme lightMaterialTheme({required VisualDensity density, required Widget child}) => Theme(
    data: buildLightMaterialTheme(density),
    child: child,
  );

  static Theme darkMaterialTheme({required VisualDensity density, required Widget child}) => Theme(
    data: buildDarkMaterialTheme(density),
    child: child,
  );

static CupertinoThemeData buildCupertinoTheme() => CupertinoThemeData(
    primaryColor: const CupertinoDynamicColor.withBrightness(
      color: Color(0xffffffff),
      darkColor: Color(0xffffffff),
    ),
    scaffoldBackgroundColor: const CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.white,
      darkColor: CupertinoColors.black,
    ),
    barBackgroundColor: const CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.white,
      darkColor: CupertinoColors.black,
    ),
    primaryContrastingColor: CupertinoDynamicColor.withBrightness(
      color: AppColors.greyMedium,
      darkColor: AppColors.greyMedium,
    ),
    textTheme: CupertinoTextThemeData(
      navTitleTextStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: const Color(0xff383838),
      ),
      navLargeTitleTextStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: const Color(0xff383838),
      ),
      actionTextStyle: const TextStyle(
        fontSize: 16,
        color: Color(0xff383838),
        fontWeight: FontWeight.normal,
      ),
      tabLabelTextStyle: const TextStyle(
        fontSize: 16,
        color: Color(0xff868686),
        fontWeight: FontWeight.normal,
      ),
      dateTimePickerTextStyle: const TextStyle(
        fontSize: 16,
        color: Color(0xffFFAC0C),
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  static CupertinoTheme darkCupertinoTheme({required Widget child,}) => CupertinoTheme(
                                                                          data: buildCupertinoTheme(),
                                                                          child: child,);
}