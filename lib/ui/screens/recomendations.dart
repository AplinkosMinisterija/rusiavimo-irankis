import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

class RecomendationScreen extends StatefulWidget {
  final String title;
  final String trashType;
  final String trashCode;
  const RecomendationScreen({
    super.key,
    required this.title,
    required this.trashCode,
    required this.trashType,
  });

  @override
  State<RecomendationScreen> createState() => _RecomendationScreenState();
}

class _RecomendationScreenState extends State<RecomendationScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        SelectionArea(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTrashBlock(),
                  _buildTrashInfoBlock(),
                ],
              ),
            ),
          ),
        ),
        _buildDescription(),
        _buildInfoContent(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInfoContent() {
    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(
              'Kaip rūšiuoti?',
              TextStyles.bussinessEntityToolWorksTitle,
            ),
            const SizedBox(height: 20),
            _buildDotContent(true),
            const SizedBox(height: 30),
            _buildTitle(
              'Kam atiduoti?',
              TextStyles.whoToGiveAwayStyle,
            ),
            const SizedBox(height: 20),
            _buildDotContent(false),
          ],
        ),
      ),
    );
  }

  Widget _buildDotContent(bool isRow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildText(),
        isRow
            ? _buildText()
            : Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.15),
                child: ElevatedButton(
                  onPressed: () {
                    js.context.callMethod('open', [
                      'https://atvr.aplinka.lt/;jsessionid=e644789de4e01d8ef3db68652bbc'
                    ]);
                  },
                  child: const Text(
                    'Daugiau informacijos',
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '* ',
                style: TextStyles.selctorColor,
              ),
              Expanded(
                child: Text(
                  InformationStrings.recommendationsListStrings[0],
                  style: TextStyles.selctorColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '* ',
                style: TextStyles.selctorColor,
              ),
              Expanded(
                child: Text(
                  InformationStrings.recommendationsListStrings[1],
                  style: TextStyles.selctorColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title, TextStyle style) {
    return Text(
      title,
      style: style,
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 100),
      child: SelectableText(
        'Lorem ipsum dolor sit amet consectetur. Sed aliquam porttitor nunc est ornare porta. Tellus faucibus commodo eleifend sed lectus neque elit. Volutpat ullamcorper quis amet pretium. Diam ultrices orci faucibus dolor proin odio neque turpis sodales.',
        style: TextStyles.contentDescription,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTrashInfoBlock() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: const EdgeInsets.fromLTRB(0, 20, 60, 20),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTypeRow(),
          _buildItemCode(),
        ],
      ),
    );
  }

  Widget _buildItemCode() {
    return Row(
      children: [
        _buildCodeWindow(widget.trashCode.split(' ')[0]),
        _buildCodeWindow(widget.trashCode.split(' ')[1]),
        _buildCodeWindow(widget.trashCode.split(' ')[2].split('*')[0]),
        _buildCodeWindow('LT'),
        _buildCodeWindow(widget.trashCode.contains('*') ? '*' : ''),
        const SizedBox(width: 10),
        const Text(
          '- atliekos kodas',
          style: TextStyles.contentDescription,
        ),
      ],
    );
  }

  Widget _buildCodeWindow(String codePart) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: (widget.trashCode == 'VP' || widget.trashCode == 'VN')
              ? AppColors.greyHooverColor
              : AppColors.scaffoldColor,
          border: (widget.trashCode == 'VP' || widget.trashCode == 'VN')
              ? null
              : Border.all(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                (widget.trashCode == 'VP' || widget.trashCode == 'VN')
                    ? ''
                    : codePart,
                style: TextStyles.itemCodeStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          widget.trashType == 'AN'
              ? Strings.approved_mark
              : Strings.red_exclemation_mark,
          width: 80,
          height: 80,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: widget.trashType == 'AN'
              ? Text(
                  '${widget.trashType} - ši atlieka yra absoliučiai nepavojinga',
                  style: TextStyles.selectorDescriptionTitleStyle,
                )
              : Text(
                  '${widget.trashType} - ši atlieka yra absoliučiai pavojinga',
                  style: TextStyles.selectorDescriptionTitleStyle,
                ),
        ),
      ],
    );
  }

  Widget _buildTrashBlock() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greenBtnUnHoover,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.09),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 80, 25, 80),
        child: Text(
          widget.title,
          style: TextStyles.trashTitle,
        ),
      ),
    );
  }
}
