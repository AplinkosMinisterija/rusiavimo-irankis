import 'package:aplinkos_ministerija/bloc/share/share_manager_cubit.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/back_btn.dart';
import 'package:aplinkos_ministerija/ui/widgets/button.dart';
import 'package:aplinkos_ministerija/utils/Dimens.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:js' as js;

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/nav_bar_bloc/nav_bar_bloc.dart';
import '../../bloc/route_controller/route_controller_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../utils/app_dialogs.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import '../widgets/accessibility.dart';
import '../widgets/mobile_extended_nav_bar.dart';
import '../widgets/mobile_nav_bar.dart';
import '../widgets/mobile_small_nav_bar.dart';
import '../widgets/web_nav_bar.dart';

class RecomendationScreen extends StatefulWidget {
  final String title;
  final String trashType;
  final String trashCode;
  final bool? fromEntryPoint;

  const RecomendationScreen({
    super.key,
    required this.title,
    required this.trashCode,
    required this.trashType,
    this.fromEntryPoint,
  });

  @override
  State<RecomendationScreen> createState() => _RecomendationScreenState();
}

class _RecomendationScreenState extends State<RecomendationScreen> {
  final ScrollController _scrollController = ScrollController();

  late ShareManagerCubit _shareManagerCubit;
  late AccessibilityControllerState _state;
  late NavBarBloc _navBarBloc;
  late FirstStageBloc _firstStageBloc;

  bool accessibilityFloat = false;

  @override
  void initState() {
    super.initState();
    _shareManagerCubit = BlocProvider.of<ShareManagerCubit>(context);
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
    _navBarBloc = BlocProvider.of<NavBarBloc>(context);
    _firstStageBloc = BlocProvider.of<FirstStageBloc>(context);
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
        padding: const EdgeInsets.only(top: 10),
        child: (MediaQuery.of(context).size.width > 768)
            ? _buildContent()
            : _buildMobileContent(),
      ),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: _buildTrashBlock(),
        ),
        BackButtonWidget(
          firstStageBloc: _firstStageBloc,
          routeControllerBloc: BlocProvider.of<RouteControllerBloc>(context),
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
          _buildItemCode(),
          const SizedBox(height: 20),
          _buildInfoContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButtonWidget(
          firstStageBloc: _firstStageBloc,
          routeControllerBloc: BlocProvider.of<RouteControllerBloc>(context),
        ),
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
        // _buildDescription(),
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
        const SizedBox(height: 20),
        _buildTitle(
          'Kaip rūšiuoti?',
          (MediaQuery.of(context).size.width > 768)
              ? _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.bussinessEntityToolWorksTitle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.bussinessEntityToolWorksTitle
                      : TextStyles.bussinessEntityToolWorksTitle
              : _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.mobileBussinessEntityToolWorksTitle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.mobileBussinessEntityToolWorksTitle
                      : TextStyles.mobileBussinessEntityToolWorksTitle,
        ),
        const SizedBox(height: 10),
        _buildText(InformationStrings.howToRecycle),
        const SizedBox(height: 30),
        _buildTitle(
          'Kam atiduoti?',
          (MediaQuery.of(context).size.width > 768)
              ? _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.whoToGiveAwayStyle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.whoToGiveAwayStyle
                      : TextStyles.whoToGiveAwayStyle
              : _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.mobileWhoToGiveAwayStyle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.mobileWhoToGiveAwayStyle
                      : TextStyles.mobileWhoToGiveAwayStyle,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: InformationStrings.whoToGiveAway[0],
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selctorColor
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selctorColor
                          : TextStyles.selctorColor,
                ),
                TextSpan(
                  text: 'Atliekų tvarkytojų valstybės registre,',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selctorColor.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selctorColor.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline)
                          : TextStyles.selctorColor.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => js.context.callMethod(
                        'open', ['https://atvr.aplinka.lt/faces/main']),
                ),
                TextSpan(
                  text: InformationStrings.whoToGiveAway[2],
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selctorColor
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selctorColor
                          : TextStyles.selctorColor,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildText(InformationStrings.whoToGiveAway[1]),
        const SizedBox(height: 30),
        _buildTitle(
          'Kaip laikyti?',
          (MediaQuery.of(context).size.width > 768)
              ? _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.bussinessEntityToolWorksTitle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.bussinessEntityToolWorksTitle
                      : TextStyles.bussinessEntityToolWorksTitle
              : _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.mobileBussinessEntityToolWorksTitle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.mobileBussinessEntityToolWorksTitle
                      : TextStyles.mobileBussinessEntityToolWorksTitle,
        ),
        const SizedBox(height: 10),
        _buildText(InformationStrings.howToStore[0]),
        const SizedBox(height: 10),
        _buildText(InformationStrings.howToStore[1]),
        const SizedBox(height: 10),
        _buildText(InformationStrings.howToStore[2]),
        const SizedBox(height: 30),
        _buildTitle(
          'Reikia konsultacijos?',
          (MediaQuery.of(context).size.width > 768)
              ? _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.whoToGiveAwayStyle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.whoToGiveAwayStyle
                      : TextStyles.whoToGiveAwayStyle
              : _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.mobileWhoToGiveAwayStyle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.mobileWhoToGiveAwayStyle
                      : TextStyles.mobileWhoToGiveAwayStyle,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: (MediaQuery.of(context).size.width > 768)
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.width,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Konsultacijas atliekų tvarkymo klausimais teikia ',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selctorColor
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selctorColor
                          : TextStyles.selctorColor,
                ),
                TextSpan(
                  text:
                      'Aplinkos apsaugos departamentas prie Aplinkos ministerijos.',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selctorColor.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selctorColor.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline)
                          : TextStyles.selctorColor.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => js.context.callMethod('open', [
                          'https://aad.lrv.lt/lt/konsultacijos-1/konsultuojame'
                        ]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildSocials(),
      ],
    );
  }

  Widget _buildSocials() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          splashRadius: 20,
          onPressed: () => _shareManagerCubit.getPdf(
            title: widget.title,
            trashType: widget.trashType,
            code: widget.trashCode,
            social: "facebook",
          ),
          icon: const Icon(FontAwesomeIcons.facebook),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () => _shareManagerCubit.getPdf(
            title: widget.title,
            trashType: widget.trashType,
            code: widget.trashCode,
            social: "messenger",
          ),
          icon: const Icon(FontAwesomeIcons.facebookMessenger),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () => _shareManagerCubit.getPdf(
            title: widget.title,
            trashType: widget.trashType,
            code: widget.trashCode,
            social: "linkedin",
          ),
          icon: const Icon(FontAwesomeIcons.linkedin),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () => _shareManagerCubit.getPdf(
            title: widget.title,
            trashType: widget.trashType,
            code: widget.trashCode,
            social: "email",
          ),
          icon: const Icon(Icons.email),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () => _shareManagerCubit.getPdf(
            title: widget.title,
            trashType: widget.trashType,
            code: widget.trashCode,
            social: "print",
          ),
          icon: const Icon(FontAwesomeIcons.print),
        ),
      ],
    );
  }

  Widget _webInfoLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _buildTitle(
                  'Kaip rūšiuoti?',
                  (MediaQuery.of(context).size.width > 768)
                      ? _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.bussinessEntityToolWorksTitle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.bussinessEntityToolWorksTitle
                              : TextStyles.bussinessEntityToolWorksTitle
                      : _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.mobileBussinessEntityToolWorksTitle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest
                                  .mobileBussinessEntityToolWorksTitle
                              : TextStyles.mobileBussinessEntityToolWorksTitle,
                ),
                const SizedBox(height: 20),
                _buildText(InformationStrings.howToRecycle),
                const SizedBox(height: 30),
                _buildTitle(
                  'Kam atiduoti?',
                  (MediaQuery.of(context).size.width > 768)
                      ? _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.whoToGiveAwayStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.whoToGiveAwayStyle
                              : TextStyles.whoToGiveAwayStyle
                      : _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.mobileWhoToGiveAwayStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.mobileWhoToGiveAwayStyle
                              : TextStyles.mobileWhoToGiveAwayStyle,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: InformationStrings.whoToGiveAway[0],
                          style:
                              _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.selctorColor
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.selctorColor
                                      : TextStyles.selctorColor,
                        ),
                        TextSpan(
                          text: 'Atliekų tvarkytojų valstybės registre,',
                          style:
                              _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.selctorColor.copyWith(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline)
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.selctorColor.copyWith(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline)
                                      : TextStyles.selctorColor.copyWith(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => js.context.callMethod(
                                'open', ['https://atvr.aplinka.lt/faces/main']),
                        ),
                        TextSpan(
                          text: InformationStrings.whoToGiveAway[2],
                          style:
                              _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.selctorColor
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.selctorColor
                                      : TextStyles.selctorColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildText(InformationStrings.whoToGiveAway[1]),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitle(
                  'Kaip laikyti?',
                  (MediaQuery.of(context).size.width > 768)
                      ? _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.bussinessEntityToolWorksTitle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.bussinessEntityToolWorksTitle
                              : TextStyles.bussinessEntityToolWorksTitle
                      : _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.mobileBussinessEntityToolWorksTitle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest
                                  .mobileBussinessEntityToolWorksTitle
                              : TextStyles.mobileBussinessEntityToolWorksTitle,
                ),
                const SizedBox(height: 20),
                _buildText(InformationStrings.howToStore[0]),
                const SizedBox(height: 10),
                _buildText(InformationStrings.howToStore[1]),
                const SizedBox(height: 10),
                _buildText(InformationStrings.howToStore[2]),
                const SizedBox(height: 30),
                _buildTitle(
                  'Reikia konsultacijos?',
                  (MediaQuery.of(context).size.width > 768)
                      ? _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.whoToGiveAwayStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.whoToGiveAwayStyle
                              : TextStyles.whoToGiveAwayStyle
                      : _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.mobileWhoToGiveAwayStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.mobileWhoToGiveAwayStyle
                              : TextStyles.mobileWhoToGiveAwayStyle,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 768)
                      ? MediaQuery.of(context).size.width * 0.4
                      : MediaQuery.of(context).size.width,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Konsultacijas atliekų tvarkymo klausimais teikia ',
                          style:
                              _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.selctorColor
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.selctorColor
                                      : TextStyles.selctorColor,
                        ),
                        TextSpan(
                          text:
                              'Aplinkos apsaugos departamentas prie Aplinkos ministerijos.',
                          style:
                              _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.selctorColor.copyWith(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline)
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.selctorColor.copyWith(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline)
                                      : TextStyles.selctorColor.copyWith(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => js.context.callMethod('open', [
                                  'https://aad.lrv.lt/lt/konsultacijos-1/konsultuojame'
                                ]),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildSocials(),
              ],
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
              Expanded(
                child: Text(
                  text,
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selctorColor
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selctorColor
                          : TextStyles.selctorColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title, TextStyle style) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.3
          : MediaQuery.of(context).size.width,
      child: Text(
        title.toCapitalized(),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTrashInfoBlock() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.fromLTRB(0, 20, 60, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTypeRow(),
          const SizedBox(height: 10),
          _buildItemCode(),
        ],
      ),
    );
  }

  Widget _buildItemCode() {
    return Row(
      mainAxisAlignment: (MediaQuery.of(context).size.width > 768)
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        _buildCodeWindow(widget.trashCode.split(' ')[0]),
        _buildCodeWindow(widget.trashCode.split(' ')[1]),
        _buildCodeWindow(widget.trashCode.split(' ')[2].split('*')[0]),
        _buildCodeWindow(
          widget.trashCode.split(' ').length > 3
              ? widget.trashCode.split(' ')[3].replaceAll('*', '')
              : '',
        ),
        _buildCodeWindow(widget.trashCode.contains('*') ? '*' : ''),
        (MediaQuery.of(context).size.width > 768)
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '- atliekos kodas',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.contentDescription
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.contentDescription
                            : TextStyles.contentDescription,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildCodeWindow(String codePart) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        width: _state.status == AccessibilityControllerStatus.biggest ? 44 : 34,
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

  Widget _buildTypeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: (MediaQuery.of(context).size.width > 768)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            widget.trashType == 'AN'
                ? (_state.blindness == AccessibilityControllerBlindness.blind)
                    ? Strings.approved_mark_monochrome
                    : Strings.approved_mark
                : widget.trashType == 'VP' || widget.trashType == 'VN'
                    ? (_state.blindness ==
                            AccessibilityControllerBlindness.blind)
                        ? Strings.question_mark_monochrome
                        : Strings.question_mark
                    : (_state.blindness ==
                            AccessibilityControllerBlindness.blind)
                        ? Strings.red_exclemation_mark_monochrome
                        : Strings.red_exclemation_mark,
            width: (MediaQuery.of(context).size.width > 768) ? 80 : 40,
            height: (MediaQuery.of(context).size.width > 768) ? 80 : 40,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  widget.trashType == 'AN'
                      ? '${widget.trashType} - ši atlieka yra absoliučiai nepavojinga'
                      : widget.trashType == "AP"
                          ? '${widget.trashType} - ši atlieka yra absoliučiai pavojinga'
                          : widget.trashType == "VP"
                              ? '${widget.trashType} - ši atlieka yra pavojinga'
                              : '${widget.trashType} - ši atlieka yra nepavojinga',
                  style: (MediaQuery.of(context).size.width > 768)
                      ? _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.selectorDescriptionTitleStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.selectorDescriptionTitleStyle
                              : TextStyles.selectorDescriptionTitleStyle
                      : _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.mobileTypeStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.mobileTypeStyle
                              : TextStyles.mobileTypeStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrashBlock() {
    return Container(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.5
          : MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppStyle.greenBtnUnHoover,
        borderRadius: (MediaQuery.of(context).size.width > 768)
            ? null
            : BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: AppStyle.black.withOpacity(0.09),
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
          widget.title.toCapitalized(),
          style: _state.status == AccessibilityControllerStatus.big
              ? TextStylesBigger.trashTitle
              : _state.status == AccessibilityControllerStatus.biggest
                  ? TextStylesBiggest.trashTitle
                  : TextStyles.trashTitle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Container _buildBg() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppStyle.blackBgWithOpacity,
    );
  }

  void accessibilityPopUp(
    BuildContext context,
  ) =>
      AppDialogs.showAnimatedDialog(
        context,
        content: const Accessibility(),
      ).whenComplete(
        () {
          _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
          setState(() {});
        },
      );
}
