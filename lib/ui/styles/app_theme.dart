import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_colors_monochrome.dart';
import '../../constants/font_family.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData themeData = ThemeData(
    fontFamily: FontFamily.foundersGrotesk,
    scaffoldBackgroundColor: AppColors.scaffoldColor,
    // primaryColor: AppColors.primary[500],
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    // unselectedWidgetColor: AppColors.accent,
    // disabledColor: AppColors.disabled,
    colorScheme: ColorScheme.fromSwatch(
      // primarySwatch: AppColors.primary,
    ).copyWith(
      // secondary: AppColors.primary[500],
      brightness: Brightness.light,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white.withOpacity(0.9),
    ),
  );

  static final ThemeData themeDataDark =  ThemeData(
    fontFamily: FontFamily.foundersGrotesk,
    scaffoldBackgroundColor: AppColorsMonochrome.scaffoldColor,
    // primaryColor: AppColorsMonochrome.accent,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    // unselectedWidgetColor: AppColorsMonochrome.accent,
    // disabledColor: AppColorsMonochrome.disabled,
    colorScheme: ColorScheme.fromSwatch(
      // primarySwatch: AppColorsMonochrome.primary,
    ).copyWith(
      // secondary: AppColorsMonochrome.primary[500],
      // brightness: Brightness.dark,
      brightness: Brightness.light,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white.withOpacity(0.9),
    ),
  );

}