import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/app_colors_monochrome.dart';
import 'package:themed/themed.dart';

class AppStyle {
  //Colors

  //Main colors
  static const scaffoldColor = ColorRef(AppColors.scaffoldColor);
  static const appBarWebColor = ColorRef(AppColors.appBarWebColor);
  static const black = ColorRef(AppColors.black);
  static const blue = ColorRef(AppColors.blue);
  static const blackBgWithOpacity = ColorRef(AppColors.blackBgWithOpacity);
  static const whiteSecondaryColor = ColorRef(AppColors.whiteSecondaryColor);
  static const overlayColor = ColorRef(AppColors.overlayColor);
  static const greyOpacity = ColorRef(AppColors.greyOpacity);

  //Buttons
  static const selectedBtnColor = ColorRef(AppColors.selectedBtnColor);
  static const unSelectedBtnColor = ColorRef(AppColors.unSelectedBtnColor);
  static const greenBtnUnHoover = ColorRef(AppColors.greenBtnUnHoover);
  static const greenBtnHoover = ColorRef(AppColors.greenBtnHoover);
  static const greyHooverColor = ColorRef(AppColors.greyHooverColor);

  //Text
  static const blueText = ColorRef(AppColors.blueText);
  static const questionsCounterColor =
      ColorRef(AppColors.questionsCounterColor);

  //Divider
  static const dividerColor = ColorRef(AppColors.dividerColor);

  //icon colors
  static const helpIconColor = ColorRef(AppColors.helpIconColor);
  static const greenCheckMark = ColorRef(AppColors.greenCheckMark);
  static const importantMark = ColorRef(AppColors.importantMark);
  static const questionMark = ColorRef(AppColors.questionMark);

  //footer colors
  static const orange = ColorRef(AppColors.orange);

  Map<ThemeRef, Object> getCurrentTheme(bool isNormalMode) {
    return {
      AppStyle.scaffoldColor: isNormalMode
          ? AppColors.scaffoldColor
          : AppColorsMonochrome.scaffoldColor,
      AppStyle.appBarWebColor: isNormalMode
          ? AppColors.appBarWebColor
          : AppColorsMonochrome.appBarWebColor,
      AppStyle.black: isNormalMode
          ? AppColors.black
          : AppColorsMonochrome.black,
      AppStyle.blue: isNormalMode
          ? AppColors.blue
          : AppColorsMonochrome.blue,
      AppStyle.blackBgWithOpacity: isNormalMode
          ? AppColors.blackBgWithOpacity
          : AppColorsMonochrome.blackBgWithOpacity,
      AppStyle.whiteSecondaryColor: isNormalMode
          ? AppColors.whiteSecondaryColor
          : AppColorsMonochrome.whiteSecondaryColor,
      AppStyle.overlayColor: isNormalMode
          ? AppColors.overlayColor
          : AppColorsMonochrome.overlayColor,
      AppStyle.greyOpacity: isNormalMode
          ? AppColors.greyOpacity
          : AppColorsMonochrome.greyOpacity,
      AppStyle.selectedBtnColor: isNormalMode
          ? AppColors.selectedBtnColor
          : AppColorsMonochrome.selectedBtnColor,
      AppStyle.unSelectedBtnColor: isNormalMode
          ? AppColors.unSelectedBtnColor
          : AppColorsMonochrome.unSelectedBtnColor,
      AppStyle.greenBtnUnHoover: isNormalMode
          ? AppColors.greenBtnUnHoover
          : AppColorsMonochrome.greenBtnUnHoover,
      AppStyle.greenBtnHoover: isNormalMode
          ? AppColors.greenBtnHoover
          : AppColorsMonochrome.greenBtnHoover,
      AppStyle.greyHooverColor: isNormalMode
          ? AppColors.greyHooverColor
          : AppColorsMonochrome.greyHooverColor,
      AppStyle.blueText: isNormalMode
          ? AppColors.blueText
          : AppColorsMonochrome.blueText,
      AppStyle.questionsCounterColor: isNormalMode
          ? AppColors.questionsCounterColor
          : AppColorsMonochrome.questionsCounterColor,
      AppStyle.dividerColor: isNormalMode
          ? AppColors.dividerColor
          : AppColorsMonochrome.dividerColor,
      AppStyle.helpIconColor: isNormalMode
          ? AppColors.helpIconColor
          : AppColorsMonochrome.helpIconColor,
      AppStyle.greenCheckMark: isNormalMode
          ? AppColors.greenCheckMark
          : AppColorsMonochrome.greenCheckMark,
      AppStyle.importantMark: isNormalMode
          ? AppColors.importantMark
          : AppColorsMonochrome.importantMark,
      AppStyle.questionMark: isNormalMode
          ? AppColors.questionMark
          : AppColorsMonochrome.questionMark,
      AppStyle.orange: isNormalMode
          ? AppColors.orange
          : AppColorsMonochrome.orange,
    };
  }
}
