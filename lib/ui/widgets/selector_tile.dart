import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildButton(),
        widget.clicked ? widget.infoWidget : const SizedBox(),
      ],
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
          height: 80,
          decoration: BoxDecoration(
            color: isHoovered || widget.clicked
                ? AppColors.greenBtnHoover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: AppColors.greenBtnHoover,
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 35, top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (MediaQuery.of(context).size.width > 762)
                    ? Text(
                        widget.title,
                        style: isHoovered || widget.clicked
                            ? TextStyles.selctorColor
                                .copyWith(color: AppColors.scaffoldColor)
                            : TextStyles.selctorColor
                                .copyWith(color: AppColors.black),
                      )
                    : AutoSizeText(
                        widget.title,
                        style: isHoovered || widget.clicked
                            ? TextStyles.selectorMobileStyle
                                .copyWith(color: AppColors.scaffoldColor)
                            : TextStyles.selectorMobileStyle
                                .copyWith(color: AppColors.black),
                        textAlign: TextAlign.left,
                        maxFontSize: 20,
                        minFontSize: 8,
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
