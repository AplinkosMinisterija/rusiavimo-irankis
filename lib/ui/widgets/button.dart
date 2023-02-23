import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../styles/text_styles.dart';

class DefaultAccentButton extends StatefulWidget {
  final Function()? onPressed;
  final String title;
  final Color? btnColor;
  final TextStyle textStyle;
  final TextAlign? textAlign;
  const DefaultAccentButton({
    super.key,
    this.onPressed,
    required this.title,
    this.btnColor = AppColors.greenBtnHoover,
    this.textStyle = TextStyles.footerBold,
    this.textAlign,
  });

  @override
  State<DefaultAccentButton> createState() => _DefaultAccentButtonState();
}

class _DefaultAccentButtonState extends State<DefaultAccentButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.btnColor,
          ),
          onPressed: widget.onPressed ?? () {},
          child: SizedBox(
            width: 180,
            height: 50,
            child: Center(
              child: Text(
                widget.title,
                style: widget.textStyle,
                textAlign: widget.textAlign,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
