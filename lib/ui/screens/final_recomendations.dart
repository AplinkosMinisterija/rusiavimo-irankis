import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

import '../../bloc/route_controller/route_controller_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../widgets/back_btn.dart';
import '../widgets/button.dart';

class FinalRecomendationsScreen extends StatefulWidget {
  final String title;
  final String trashType;
  final RouteControllerBloc routeControllerBloc;
  final FirstStageBloc firstStageBloc;

  const FinalRecomendationsScreen({
    super.key,
    required this.title,
    required this.trashType,
    required this.routeControllerBloc,
    required this.firstStageBloc,
  });

  @override
  State<FinalRecomendationsScreen> createState() =>
      _FinalRecomendationsScreenState();
}

class _FinalRecomendationsScreenState extends State<FinalRecomendationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: (MediaQuery.of(context).size.width > 768)
          ? _buildContent()
          : _buildMobileContent(),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButtonWidget(
                firstStageBloc: widget.firstStageBloc,
                routeControllerBloc: widget.routeControllerBloc,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: _buildTrashBlock(),
        ),
        _buildMobileTrashInfoBlock(),
      ],
    );
  }

  Widget _buildMobileTrashInfoBlock() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          _buildTypeRow(),
          const SizedBox(height: 20),
          _buildInfoContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButtonWidget(
                firstStageBloc: widget.firstStageBloc,
                routeControllerBloc: widget.routeControllerBloc,
              ),
            ],
          ),
        ),
        SelectionArea(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTrashBlock(),
                  _buildTrashInfoBlock(),
                ],
              ),
            ),
          ),
        ),
        _buildInfoContent(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInfoContent() {
    return SelectionArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width > 768) ? 100 : 10,
        ),
        child: (MediaQuery.of(context).size.width > 768)
            ? _webInfoLayout()
            : _mobileInfoLayout(),
      ),
    );
  }

  Widget _mobileInfoLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(
          'Kaip rūšiuoti?',
          (MediaQuery.of(context).size.width > 768)
              ? TextStyles.bussinessEntityToolWorksTitle
              : TextStyles.mobileBussinessEntityToolWorksTitle,
        ),
        const SizedBox(height: 20),
        _buildText(InformationStrings.howToRecycle),
        const SizedBox(height: 30),
        _buildTitle(
          'Kam atiduoti?',
          (MediaQuery.of(context).size.width > 768)
              ? TextStyles.whoToGiveAwayStyle
              : TextStyles.mobileWhoToGiveAwayStyle,
        ),
        const SizedBox(height: 20),
        _buildText(InformationStrings.whoToGiveAway[0]),
        _buildText(InformationStrings.whoToGiveAway[1]),
        _buildTitle(
          'Kaip laikyti?',
          (MediaQuery.of(context).size.width > 768)
              ? TextStyles.bussinessEntityToolWorksTitle
              : TextStyles.mobileBussinessEntityToolWorksTitle,
        ),
        const SizedBox(height: 20),
        _buildText(InformationStrings.howToStore[0]),
        _buildText(InformationStrings.howToStore[1]),
        _buildText(InformationStrings.howToStore[2]),
        const SizedBox(height: 30),
        _buildTitle(
          'Reikia konsultacijos?',
          (MediaQuery.of(context).size.width > 768)
              ? TextStyles.whoToGiveAwayStyle
              : TextStyles.mobileWhoToGiveAwayStyle,
        ),
        const SizedBox(height: 20),
        _buildText(InformationStrings.helpString),
        Align(
          alignment: Alignment.center,
          child: DefaultAccentButton(
            title: 'Daugiau informacijos',
            textStyle: TextStyles.mobileBtnStyle,
            onPressed: () {
              js.context.callMethod('open', [
                'https://atvr.aplinka.lt/;jsessionid=e644789de4e01d8ef3db68652bbc'
              ]);
            },
          ),
        ),
      ],
    );
  }

  Widget _webInfoLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildTitle(
              'Kaip rūšiuoti?',
              (MediaQuery.of(context).size.width > 768)
                  ? TextStyles.bussinessEntityToolWorksTitle
                  : TextStyles.mobileBussinessEntityToolWorksTitle,
            ),
            const SizedBox(height: 20),
            _buildText(InformationStrings.howToRecycle),
            const SizedBox(height: 30),
            _buildTitle(
              'Kam atiduoti?',
              (MediaQuery.of(context).size.width > 768)
                  ? TextStyles.whoToGiveAwayStyle
                  : TextStyles.mobileWhoToGiveAwayStyle,
            ),
            const SizedBox(height: 20),
            _buildText(InformationStrings.whoToGiveAway[0]),
            _buildText(InformationStrings.whoToGiveAway[1]),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTitle(
              'Kaip laikyti?',
              (MediaQuery.of(context).size.width > 768)
                  ? TextStyles.bussinessEntityToolWorksTitle
                  : TextStyles.mobileBussinessEntityToolWorksTitle,
            ),
            const SizedBox(height: 20),
            _buildText(InformationStrings.howToStore[0]),
            _buildText(InformationStrings.howToStore[1]),
            _buildText(InformationStrings.howToStore[2]),
            const SizedBox(height: 30),
            _buildTitle(
              'Reikia konsultacijos?',
              (MediaQuery.of(context).size.width > 768)
                  ? TextStyles.whoToGiveAwayStyle
                  : TextStyles.mobileWhoToGiveAwayStyle,
            ),
            const SizedBox(height: 20),
            _buildText(InformationStrings.helpString),
            DefaultAccentButton(
              title: 'Daugiau informacijos',
              textStyle: TextStyles.mobileBtnStyle,
              onPressed: () {
                js.context.callMethod('open', [
                  'https://atvr.aplinka.lt/;jsessionid=e644789de4e01d8ef3db68652bbc'
                ]);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width,
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
                  text,
                  style: TextStyles.selctorColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTitle(String title, TextStyle style) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.18
          : MediaQuery.of(context).size.width,
      child: Text(
        title,
        style: style,
      ),
    );
  }

  Widget _buildTrashInfoBlock() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.fromLTRB(0, 20, 60, 20),
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
      mainAxisAlignment: (MediaQuery.of(context).size.width > 768)
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          widget.trashType == 'AN'
              ? Strings.approved_mark
              : Strings.red_exclemation_mark,
          width: (MediaQuery.of(context).size.width > 768) ? 80 : 40,
          height: (MediaQuery.of(context).size.width > 768) ? 80 : 40,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: widget.trashType == 'AN'
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'Ši atlieka yra nepavojinga',
                    style: (MediaQuery.of(context).size.width > 768)
                        ? TextStyles.selectorDescriptionTitleStyle
                        : TextStyles.mobileTypeStyle,
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'Ši atlieka yra pavojinga',
                    style: (MediaQuery.of(context).size.width > 768)
                        ? TextStyles.selectorDescriptionTitleStyle
                        : TextStyles.mobileTypeStyle,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTrashBlock() {
    return Container(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.5
          : MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.greenBtnUnHoover,
        borderRadius: (MediaQuery.of(context).size.width > 768)
            ? null
            : BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.09),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: (MediaQuery.of(context).size.width > 768)
            ? const EdgeInsets.fromLTRB(30, 80, 25, 80)
            : const EdgeInsets.all(25),
        child: Text(
          widget.title,
          style: TextStyles.trashTitle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
