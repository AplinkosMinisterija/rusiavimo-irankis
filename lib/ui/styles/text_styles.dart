import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/font_family.dart';
import 'package:flutter/material.dart';

class TextStyles {
  TextStyles._();

  static const navigationBtnSelectedStyle = TextStyle(
    fontFamily: FontFamily.foundersGrotesk,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    color: AppColors.selectedBtnColor,
  );

  static const navigationBtnUnSelectedStyle = TextStyle(
    fontFamily: FontFamily.foundersGrotesk,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    color: AppColors.unSelectedBtnColor,
  );

  static const navigationDescriptionStyle = TextStyle(
    fontFamily: FontFamily.foundersGrotesk,
    fontWeight: FontWeight.w600,
    fontSize: 52,
    color: AppColors.black,
  );

  static const navigationSecondDescriptionStyle = TextStyle(
    fontFamily: FontFamily.foundersGrotesk,
    fontWeight: FontWeight.w600,
    fontSize: 52,
    color: AppColors.blueText,
  );

  static const routeTracker = TextStyle(
    fontFamily: FontFamily.foundersGrotesk,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.black,
  );

  static const contentDescription = TextStyle(
    fontFamily: FontFamily.foundersGrotesk,
    fontWeight: FontWeight.w400,
    fontSize: 26,
    color: AppColors.black,
  );

  static const btnText = TextStyle(
    fontFamily: FontFamily.foundersGrotesk,
    fontWeight: FontWeight.w600,
    fontSize: 38,
    letterSpacing: 0.3,
    color: AppColors.scaffoldColor,
  );
}
