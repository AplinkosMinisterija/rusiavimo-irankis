import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
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
  final bool? isHooverAnimationEnabled;

  const DefaultAccentButton({
    super.key,
    this.onPressed,
    required this.title,
    this.btnColor = AppStyle.greenBtnHoover,
    this.textStyle = TextStyles.footerBold,
    this.textAlign,
    this.paddingFromTop = 0,
    this.isHooverAnimationEnabled = false,
  });

  @override
  State<DefaultAccentButton> createState() => _DefaultAccentButtonState();
}

class _DefaultAccentButtonState extends State<DefaultAccentButton> {
  late AccessibilityControllerState _state;
  late Color hooverColor;

  @override
  void initState() {
    super.initState();
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
    hooverColor = widget.btnColor!;
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
        onEnter: (e) {
          hooverColor = AppColors.questionsCounterColor;
          setState(() {});
        },
        onExit: (e) {
          hooverColor = widget.btnColor!;
          setState(() {});
        },
        child: ElevatedButton(
          style: widget.isHooverAnimationEnabled!
              ? ElevatedButton.styleFrom(
                  backgroundColor: hooverColor,
                  shadowColor: Colors.transparent,
                )
              : ElevatedButton.styleFrom(
                  backgroundColor: widget.btnColor,
                ),
          onPressed: widget.onPressed ?? () {},
          child: SizedBox(
            width: 180,
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(top: widget.paddingFromTop!),
              child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Padding(
                    padding: _state.status ==
                            AccessibilityControllerStatus.normal
                        ? const EdgeInsets.only(top: 2)
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? const EdgeInsets.only(top: 4)
                            : const EdgeInsets.only(top: 5),
                    child: Text(
                      widget.title,
                      style: widget.textStyle,
                      textAlign: widget.textAlign,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
