import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../model/category.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class ItemsTile extends StatefulWidget {
  final bool isTitleRowRequired;
  final String descriptionTitle;
  final String trashCode;
  final String toolTipMsg;
  final String code;
  final FirstStageBloc firstStageBloc;
  final List<Category> listOfCategories;

  const ItemsTile({
    super.key,
    required this.isTitleRowRequired,
    required this.descriptionTitle,
    required this.trashCode,
    required this.toolTipMsg,
    required this.code,
    required this.firstStageBloc,
    required this.listOfCategories,
  });

  @override
  State<ItemsTile> createState() => _ItemsTileState();
}

class _ItemsTileState extends State<ItemsTile> {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.isTitleRowRequired
              ? SelectionArea(
                  child: _buildTitleRow(),
                )
              : const SizedBox(),
          const SizedBox(height: 20),
          _buildInfoRow(),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Tooltip(
      message: widget.toolTipMsg,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: AppStyle.appBarWebColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.23,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SelectableText(
                    widget.descriptionTitle,
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.contentDescription
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.contentDescription
                            : TextStyles.contentDescription,
                  ),
                ),
              ),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SelectionArea(child: _buildItemCodeMark()),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                SelectionArea(child: _buildItemCode()),
                const SizedBox(width: 20),
                _buildButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      height: 50,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppStyle.greenBtnUnHoover),
        onPressed: () {
          widget.firstStageBloc.add(
            OpenSecondStageEvent(
              trashCode: widget.code,
              title: widget.descriptionTitle,
              trashType: widget.trashCode,
              listOfCategories: widget.listOfCategories,
            ),
          );
          Navigator.of(context).pop();
          // }
        },
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            'Eiti toliau',
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.searchBtnStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.searchBtnStyle
                    : TextStyles.searchBtnStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildItemCode() {
    return Row(
      children: [
        _buildCodeWindow(widget.code.split(' ')[0]),
        _buildCodeWindow(widget.code.split(' ')[1]),
        _buildCodeWindow(widget.code.split(' ')[2].split('*')[0]),
        _buildCodeWindow(''),
        _buildCodeWindow(widget.code.contains('*') ? '*' : ''),
      ],
    );
  }

  Widget _buildCodeWindow(String codePart) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        width: _state.status == AccessibilityControllerStatus.biggest ? 44 : 32,
        decoration: BoxDecoration(
          color: (widget.trashCode == 'VP' || widget.trashCode == 'VN')
              ? AppStyle.greyHooverColor
              : AppStyle.scaffoldColor,
          border: (widget.trashCode == 'VP' || widget.trashCode == 'VN')
              ? null
              : Border.all(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: _state.status == AccessibilityControllerStatus.biggest
                    ? 10
                    : 5,
              ),
              child: Text(
                (widget.trashCode == 'VP' || widget.trashCode == 'VN')
                    ? ''
                    : codePart,
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.itemCodeStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.itemCodeStyle
                        : TextStyles.itemCodeStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCodeMark() {
    return Row(
      children: [
        Image.asset(
          widget.trashCode == 'AN'
              ? Strings.approved_mark
              : widget.trashCode == 'AP'
                  ? Strings.red_exclemation_mark
                  : Strings.question_mark,
          width: 30,
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            widget.trashCode,
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.contentDescription
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.contentDescription
                    : TextStyles.contentDescription,
          ),
        )
      ],
    );
  }

  Widget _buildTitleRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Atliekos apibūdinimas',
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.selectorDescriptionTitleStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.selectorDescriptionTitleStyle
                    : TextStyles.selectorDescriptionTitleStyle,
          ),
          const SizedBox(),
          Text(
            'Atliekos kodas',
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.selectorDescriptionTitleStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.selectorDescriptionTitleStyle
                    : TextStyles.selectorDescriptionTitleStyle,
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
