import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_theme.dart';

class AppTextStyle {
  AppTextStyle._();

  static black([double fontSize = 16, FontWeight fontWeight = FontWeight.w500]) => GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.black,
      );

  static white([double fontSize = 16, FontWeight fontWeight = FontWeight.w500]) => GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.white,
      );

  static primary([double fontSize = 16, FontWeight fontWeight = FontWeight.w500]) => GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.primary,
      );

  static secondary([double fontSize = 16, FontWeight fontWeight = FontWeight.w500]) => GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.secondary,
      );

  static disable([double fontSize = 14, FontWeight fontWeight = FontWeight.w500]) => GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.disable,
      );

  static error([double fontSize = 14, FontWeight fontWeight = FontWeight.w600]) => GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.error,
      );

  static custom([double fontSize = 16, FontWeight fontWeight = FontWeight.w500, Color color = AppColors.primary]) =>
      GoogleFonts.montserrat(fontSize: fontSize, fontWeight: fontWeight, color: Colors.grey);
}
