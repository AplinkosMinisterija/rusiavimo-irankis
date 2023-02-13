import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatefulWidget {
  final String toolTipMsg;
  final Function()? onPressed;
  final Color? shadowColor;
  final Color? backgroundColor;
  final Color? hoverColor;
  final String btnText;
  final TextStyle? btnTextStyle;
  final double? padding;
  final bool? isPressed;
  const DefaultButton({
    super.key,
    required this.toolTipMsg,
    this.onPressed,
    this.backgroundColor = AppColors.appBarWebColor,
    this.shadowColor = AppColors.appBarWebColor,
    this.hoverColor = AppColors.greyHooverColor,
    required this.btnText,
    this.btnTextStyle = TextStyles.contentDescription,
    this.padding = 20,
    this.isPressed = false,
  });

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  bool isHoovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.toolTipMsg,
      textStyle: TextStyles.toolTipTextStyle,
      preferBelow: false,
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        border: Border.fromBorderSide(
          BorderSide(
            color: AppColors.black.withOpacity(0.46),
          ),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            isHoovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHoovered = false;
          });
        },
        child: ElevatedButton(
          onPressed: widget.onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            shadowColor: widget.shadowColor,
            backgroundColor: isHoovered || widget.isPressed!
                ? widget.hoverColor
                : widget.backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.padding!),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.btnText,
                style: widget.btnTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
