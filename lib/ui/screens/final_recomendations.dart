import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

class FinalRecomendationsScreen extends StatefulWidget {
  final String title;
  final String trashType;
  const FinalRecomendationsScreen({
    super.key,
    required this.title,
    required this.trashType,
  });

  @override
  State<FinalRecomendationsScreen> createState() => _FinalRecomendationsScreenState();
}

class _FinalRecomendationsScreenState extends State<FinalRecomendationsScreen> {
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
      title.toCapitalized(),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTypeRow(),
        ],
      ),
    );
  }

  Widget _buildTypeRow() {
    return Row(
      children: [
        Image.asset(
          widget.trashType == 'AN'
              ? Strings.approved_mark
              : Strings.red_exclemation_mark,
          width: 80,
          height: 80,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: widget.trashType == 'AN'
              ? const Text(
            'ši atlieka yra nepavojinga',
            style: TextStyles.selectorDescriptionTitleStyle,
          )
              : const Text(
            'ši atlieka yra pavojinga',
            style: TextStyles.selectorDescriptionTitleStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildTrashBlock() {
    return Container(
      width: 1000,
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
