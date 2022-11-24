import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_boxtv/core/theme/text_theme.dart';

import 'color_theme.dart';

class AppTheme {
  AppTheme._();

  static const double _defaultBorderRadius = 10;
  static const double _defaultFontSize = 16;
  static const Size _sizeButton = Size(88, 50);

  static ThemeData get light => ThemeData(
        // * Fonts
        textTheme: GoogleFonts.montserratTextTheme(Get.textTheme),
        fontFamily: GoogleFonts.montserrat().fontFamily,
        primaryTextTheme: GoogleFonts.montserratTextTheme(),

        // * Colors
        primaryColor: AppColors.primary,
        primaryColorDark: AppColors.primaryDark,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        disabledColor: AppColors.disable,
        errorColor: AppColors.error,
        hintColor: AppColors.disable,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),

        // * TextField
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: AppTextStyle.error(13),
          labelStyle: AppTextStyle.secondary(_defaultFontSize),
          hintStyle: AppTextStyle.custom(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_defaultBorderRadius),
            borderSide: BorderSide(color: AppColors.error.withOpacity(.4), width: 1.8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_defaultBorderRadius),
            borderSide: BorderSide(color: AppColors.error.withOpacity(.4), width: 1.8),
          ),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
          isDense: true,
          errorMaxLines: 2,
        ),

        // * Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
            textStyle: AppTextStyle.white(_defaultFontSize, FontWeight.bold),
            minimumSize: _sizeButton,
          ),
        ),

        // * Outlined Button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
            side: const BorderSide(width: 1.2),
            animationDuration: const Duration(milliseconds: 400),
            textStyle: AppTextStyle.white(_defaultFontSize, FontWeight.bold),
            minimumSize: _sizeButton,
          ),
        ),

        // * Text Button
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
            textStyle: AppTextStyle.white(_defaultFontSize, FontWeight.bold),
            minimumSize: _sizeButton,
          ),
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primary,
          disabledColor: AppColors.disable,
          colorScheme: Get.theme.colorScheme,
        ),

        // * AppBar
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarBrightness: GetPlatform.isAndroid ? Brightness.light : Brightness.dark,
            statusBarIconBrightness: GetPlatform.isAndroid ? Brightness.light : Brightness.dark,
          ),
          elevation: 0,
          centerTitle: true,
          color: Colors.black,
          titleSpacing: 0,
          toolbarTextStyle: GoogleFonts.montserrat(),
          titleTextStyle: GoogleFonts.montserrat(),
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),

        visualDensity: VisualDensity.comfortable,
      );

  static ThemeData get dark => ThemeData(
        // * Fonts
        textTheme: GoogleFonts.notoSansTextTheme(Get.textTheme),
        fontFamily: GoogleFonts.notoSans().fontFamily,
        primaryTextTheme: GoogleFonts.notoSansTextTheme(),

        // * Colors
        primaryColor: AppColors.primaryDark,
        primaryColorDark: AppColors.primary,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        disabledColor: AppColors.disable,
        errorColor: AppColors.error,
        hintColor: AppColors.disable,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryDark,
          secondary: AppColors.secondaryDark,
        ),

        // * TextField
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: AppTextStyle.error(13),
          labelStyle: AppTextStyle.secondary(_defaultFontSize),
          hintStyle: AppTextStyle.custom(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_defaultBorderRadius),
            borderSide: BorderSide(color: AppColors.error.withOpacity(.4), width: 1.8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_defaultBorderRadius),
            borderSide: BorderSide(color: AppColors.error.withOpacity(.4), width: 1.8),
          ),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
          isDense: true,
          errorMaxLines: 2,
        ),

        // * Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
            textStyle: AppTextStyle.white(_defaultFontSize, FontWeight.bold),
            minimumSize: _sizeButton,
          ),
        ),

        // * Outlined Button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
            textStyle: AppTextStyle.white(_defaultFontSize, FontWeight.bold),
            minimumSize: _sizeButton,
          ),
        ),

        // * Text Button
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_defaultBorderRadius)),
            textStyle: AppTextStyle.white(_defaultFontSize, FontWeight.bold),
            minimumSize: _sizeButton,
          ),
        ),

        // * AppBar
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarBrightness: GetPlatform.isAndroid ? Brightness.light : Brightness.dark,
            statusBarIconBrightness: GetPlatform.isAndroid ? Brightness.light : Brightness.dark,
          ),
          elevation: 0,
          centerTitle: true,
          color: Colors.black,
          titleSpacing: 0,
          toolbarTextStyle: GoogleFonts.montserrat(),
          titleTextStyle: GoogleFonts.montserrat(),
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
      );
}
