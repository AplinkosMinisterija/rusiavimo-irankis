import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class SelectorTile extends StatefulWidget {
  final String title;
  final Function() onTap;
  final bool clicked;
  final Widget infoWidget;

  SelectorTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.clicked,
    required this.infoWidget,
  });

  @override
  State<SelectorTile> createState() => _SelectorTileState();
}

class _SelectorTileState extends State<SelectorTile> {
  bool isHoovered = false;
  bool isSelected = false;
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
      child: Column(
        children: [
          _buildButton(),
          widget.clicked ? widget.infoWidget : const SizedBox(),
        ],
      ),
    );
  }

  GestureDetector _buildButton() {
    return GestureDetector(
      onTap: widget.onTap,
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            color: isHoovered || widget.clicked
                ? AppStyle.greenBtnHoover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: AppStyle.greenBtnHoover,
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: (MediaQuery.of(context).size.width > 762)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.title,
                        style: isHoovered || widget.clicked
                            ? _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.selctorColor
                                    .copyWith(color: AppStyle.scaffoldColor)
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBigger.selctorColor
                                        .copyWith(color: AppStyle.scaffoldColor)
                                    : TextStyles.selctorColor
                                        .copyWith(color: AppStyle.scaffoldColor)
                            : _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.selctorColor
                                    .copyWith(color: AppStyle.black)
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBigger.selctorColor
                                        .copyWith(color: AppStyle.black)
                                    : TextStyles.selctorColor
                                        .copyWith(color: AppStyle.black),
                      ),
                    )
                  : Padding(
                    padding: _state.status == AccessibilityControllerStatus.normal
                        ? const EdgeInsets.only(top: 5)
                        : _state.status == AccessibilityControllerStatus.biggest
                        ? const EdgeInsets.only(top: 10)
                        : const EdgeInsets.only(top: 7),
                    child: Text(
                        widget.title,
                        style: isHoovered || widget.clicked
                            ? _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.selectorMobileStyle
                                    .copyWith(color: AppStyle.scaffoldColor)
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBigger.selectorMobileStyle
                                        .copyWith(color: AppStyle.scaffoldColor)
                                    : TextStyles.selectorMobileStyle
                                        .copyWith(color: AppStyle.scaffoldColor)
                            : _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.selectorMobileStyle
                                    .copyWith(color: AppStyle.black)
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBigger.selectorMobileStyle
                                        .copyWith(color: AppStyle.black)
                                    : TextStyles.selectorMobileStyle
                                        .copyWith(color: AppStyle.black),
                        textAlign: TextAlign.left,
                        // maxFontSize: 20,
                        // minFontSize: 8,
                        // maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
