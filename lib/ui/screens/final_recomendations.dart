import 'package:aplinkos_ministerija/bloc/nav_bar_bloc/nav_bar_bloc.dart';
import 'package:aplinkos_ministerija/bloc/share/share_manager_cubit.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:js' as js;

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/route_controller/route_controller_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../utils/app_dialogs.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import '../widgets/accessibility.dart';
import '../widgets/back_btn.dart';
import '../widgets/button.dart';
import '../widgets/mobile_extended_nav_bar.dart';
import '../widgets/mobile_nav_bar.dart';
import '../widgets/mobile_small_nav_bar.dart';
import '../widgets/web_nav_bar.dart';

class FinalRecomendationsScreen extends StatefulWidget {
  final String title;
  final String trashType;

  const FinalRecomendationsScreen({
    super.key,
    required this.title,
    required this.trashType,
  });

  @override
  State<FinalRecomendationsScreen> createState() =>
      _FinalRecomendationsScreenState();
}

class _FinalRecomendationsScreenState extends State<FinalRecomendationsScreen> {
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
      child: BlocBuilder<NavBarBloc, NavBarState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: MediaQuery.of(context).size.width > 768
                    ? null
                    : _buildMobileAppBar(),
                floatingActionButton: (MediaQuery.of(context).size.width > 768)
                    ? Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => accessibilityPopUp(context),
                    child: MouseRegion(
                      onExit: (e) {
                        accessibilityFloat = false;
                        setState(() {});
                      },
                      onEnter: (e) {
                        accessibilityFloat = true;
                        setState(() {});
                      },
                      child: Transform.scale(
                        scale: accessibilityFloat ? 1.1 : 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: accessibilityFloat
                                ? AppStyle.greenBtnHoover
                                : AppStyle.greenBtnUnHoover,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.accessibility,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    : null,
                body: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: (MediaQuery.of(context).size.width > 768)
                        ? _buildContent()
                        : _buildMobileContent(),
                  ),
                ),
              ),
              state is NavBarOpenState
                  ? GestureDetector(
                      onTap: () {
                        _navBarBloc.add(CloseNavBarEvent());
                      },
                      child: _buildBg(),
                    )
                  : const SizedBox(),
              state is NavBarOpenState
                  ? ExtendedMobileNavBar(
                      navBarBloc: _navBarBloc,
                      firstStageBloc: _firstStageBloc,
                      onAccessibilityPress: () {
                        _navBarBloc.add(CloseNavBarEvent());
                        accessibilityPopUp(context);
                      },
                    )
                  : const SizedBox(),
            ],
          );
        },
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

  PreferredSizeWidget _buildMobileAppBar() {
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        75,
      ),
      child: MobileNavBar(navBarBloc: _navBarBloc),
    );
  }

  Widget _buildWebAppBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: _state.status == AccessibilityControllerStatus.big
          ? 250
          : _state.status == AccessibilityControllerStatus.biggest
              ? 270
              : 240,
      child: const WebNavBar(),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
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
        _buildWebAppBar(),
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
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        _buildText(InformationStrings.whoToGiveAway[0]),
        _buildText(InformationStrings.whoToGiveAway[1]),
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
        const SizedBox(height: 20),
        _buildText(InformationStrings.howToStore[0]),
        _buildText(InformationStrings.howToStore[1]),
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
        const SizedBox(height: 20),
        _buildText(InformationStrings.helpString),
        Align(
          alignment: Alignment.center,
          child: DefaultAccentButton(
            title: 'Daugiau informacijos',
            textStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.mobileBtnStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.mobileBtnStyle
                    : TextStyles.mobileBtnStyle,
            textAlign: TextAlign.center,
            onPressed: () {
              js.context.callMethod('open',
                  ['https://aad.lrv.lt/lt/konsultacijos-1/konsultuojame']);
            },
          ),
        ),
        const SizedBox(height: 10),
        CircleAvatar(
          radius: 30,
          backgroundColor: AppStyle.greenBtnUnHoover,
          child: IconButton(
            onPressed: () {
              _shareManagerCubit.getFinalPdf(
                title: widget.title,
                trashType: widget.trashType,
              );
            },
            icon: const Icon(
              Icons.save_alt,
              color: Colors.white,
            ),
          ),
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
                _buildText(InformationStrings.howToStore[1]),
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
                _buildText(InformationStrings.helpString),
                DefaultAccentButton(
                  title: 'Daugiau informacijos',
                  textStyle: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.mobileBtnStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.mobileBtnStyle
                          : TextStyles.mobileBtnStyle,
                  textAlign: TextAlign.center,
                  onPressed: () {
                    js.context.callMethod('open', [
                      'https://aad.lrv.lt/lt/konsultacijos-1/konsultuojame'
                    ]);
                  },
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: AppStyle.greenBtnUnHoover,
          child: IconButton(
            onPressed: () {
              _shareManagerCubit.getFinalPdf(
                title: widget.title,
                trashType: widget.trashType,
              );
            },
            icon: const Icon(
              Icons.save_alt,
              color: Colors.white,
            ),
          ),
        ),
        // DefaultAccentButton(
        //   title: 'Išsaugoti rezultatą',
        //   textStyle: _state.status == AccessibilityControllerStatus.big
        //       ? TextStylesBigger.mobileBtnStyle
        //       : _state.status == AccessibilityControllerStatus.biggest
        //           ? TextStylesBiggest.mobileBtnStyle
        //           : TextStyles.mobileBtnStyle,
        //   onPressed: () {
        //     _shareManagerCubit.getFinalPdf(
        //       title: widget.title,
        //       trashType: widget.trashType,
        //     );
        //   },
        // ),
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
              Text(
                '• ',
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.selctorColor
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.selctorColor
                        : TextStyles.selctorColor,
              ),
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
                        ? _state.status == AccessibilityControllerStatus.big
                            ? TextStylesBigger.selectorDescriptionTitleStyle
                            : _state.status ==
                                    AccessibilityControllerStatus.biggest
                                ? TextStylesBiggest
                                    .selectorDescriptionTitleStyle
                                : TextStyles.selectorDescriptionTitleStyle
                        : _state.status == AccessibilityControllerStatus.big
                            ? TextStylesBigger.mobileTypeStyle
                            : _state.status ==
                                    AccessibilityControllerStatus.biggest
                                ? TextStylesBiggest.mobileTypeStyle
                                : TextStyles.mobileTypeStyle,
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'Ši atlieka yra pavojinga',
                    style: (MediaQuery.of(context).size.width > 768)
                        ? _state.status == AccessibilityControllerStatus.big
                            ? TextStylesBigger.selectorDescriptionTitleStyle
                            : _state.status ==
                                    AccessibilityControllerStatus.biggest
                                ? TextStylesBiggest
                                    .selectorDescriptionTitleStyle
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
      ],
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
          widget.title,
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
