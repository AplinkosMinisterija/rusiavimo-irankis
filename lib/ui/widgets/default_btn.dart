import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class DefaultButton extends StatefulWidget {
  final String? toolTipMsg;
  final Function()? onPressed;
  final Color? shadowColor;
  final Color? backgroundColor;
  final Color? hoverColor;
  final String btnText;
  final TextStyle btnTextStyle;
  final double? padding;
  final bool? isPressed;

  const DefaultButton({
    super.key,
    this.toolTipMsg,
    this.onPressed,
    this.backgroundColor = AppStyle.appBarWebColor,
    this.shadowColor = AppStyle.appBarWebColor,
    this.hoverColor = AppStyle.greyHooverColor,
    required this.btnText,
    required this.btnTextStyle,
    this.padding = 20,
    this.isPressed = false,
  });

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  bool isHoovered = false;
  late AccessibilityControllerState _state;

  @override
  void initState() {
    super.initState();
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccessibilityControllerCubit,
        AccessibilityControllerState>(
      listener: (context, state) {
        _state = state;
        setState(() {});
      },
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
            alignment: Alignment.centerLeft,
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
