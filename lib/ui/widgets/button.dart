import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';

class DefaultAccentButton extends StatefulWidget {
  final Function()? onPressed;
  final String title;
  final Color? btnColor;
  final TextStyle textStyle;
  final TextAlign? textAlign;
  final double? paddingFromTop;

  const DefaultAccentButton({
    super.key,
    this.onPressed,
    required this.title,
    this.btnColor = AppStyle.greenBtnHoover,
    this.textStyle = TextStyles.footerBold,
    this.textAlign,
    this.paddingFromTop = 0,
  });

  @override
  State<DefaultAccentButton> createState() => _DefaultAccentButtonState();
}

class _DefaultAccentButtonState extends State<DefaultAccentButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.btnColor,
        alignment: Alignment.center,
      ),
      onPressed: widget.onPressed ?? () {},
      child: Text(
        widget.title,
        style: widget.textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
