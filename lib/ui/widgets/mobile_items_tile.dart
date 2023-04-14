import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../model/category.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class MobileItemsTile extends StatefulWidget {
  final String code;
  final String trashType;
  final String itemName;
  final FirstStageBloc firstStageBloc;
  final List<Category> listOfCategories;

  const MobileItemsTile({
    Key? key,
    required this.code,
    required this.trashType,
    required this.itemName,
    required this.firstStageBloc,
    required this.listOfCategories,
  }) : super(key: key);

  @override
  State<MobileItemsTile> createState() => _MobileItemsTileState();
}

class _MobileItemsTileState extends State<MobileItemsTile> {
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppStyle.appBarWebColor,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppStyle.greenBtnHoover)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLeftContent(),
                    Expanded(
                      child: DefaultAccentButton(
                        title: 'Eiti toliau',
                        paddingFromTop: 4,
                        onPressed: () {
                          widget.firstStageBloc.add(
                            OpenSecondStageEvent(
                              trashCode: widget.code,
                              title: widget.itemName,
                              trashType: widget.trashType,
                              listOfCategories: widget.listOfCategories,
                            ),
                          );
                        },
                        textStyle:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.mobileBtnStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.mobileBtnStyle
                                    : TextStyles.mobileBtnStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCode(),
      ],
    );
  }

  Widget _buildCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              (widget.trashType == 'AP')
                  ? Strings.red_exclemation_mark
                  : (widget.trashType == 'AN')
                      ? Strings.approved_mark
                      : Strings.question_mark,
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  (widget.trashType == 'AP')
                      ? 'Absoliučiai pavojinga'
                      : (widget.trashType == 'AN')
                          ? 'Absoliučiai nepavojinga'
                          : 'Reikia atlikti įvertinimą',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.mobileTrashTypeStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.mobileTrashTypeStyle
                          : TextStyles.mobileTrashTypeStyle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        _buildItemCode()
      ],
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      width: 280,
      child: Text(
        widget.itemName.toCapitalized(),
        style: _state.status == AccessibilityControllerStatus.big
            ? TextStylesBigger.mobileContentDescription
            : _state.status == AccessibilityControllerStatus.biggest
                ? TextStylesBiggest.mobileContentDescription
                : TextStyles.mobileContentDescription,
      ),
    );
  }

  Widget _buildItemCode() {
    return Row(
      children: [
        _buildCodeWindow(widget.code.split(' ')[0]),
        _buildCodeWindow(widget.code.split(' ')[1]),
        _buildCodeWindow(widget.code.split(' ')[2].split('*')[0]),
        _buildCodeWindow(' '),
        _buildCodeWindow(widget.code.contains('*') ? '*' : ' '),
      ],
    );
  }

  Widget _buildCodeWindow(String codePart) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        // width: 24,
        width: _state.status == AccessibilityControllerStatus.biggest ? 30 : 24,
        decoration: BoxDecoration(
          color: AppStyle.scaffoldColor,
          border: Border.all(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                codePart,
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.mobileItemStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.mobileItemStyle
                        : TextStyles.mobileItemStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
