import 'dart:async';

import 'package:aplinkos_ministerija/bloc/accessibility_controller/accessibility_controller_cubit.dart';
import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/ui/screens/bussiness.dart';
import 'package:aplinkos_ministerija/ui/screens/residents.dart';
import 'package:aplinkos_ministerija/ui/styles/app_style.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles_biggest.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_extended_nav_bar.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_nav_bar.dart';
import 'package:aplinkos_ministerija/ui/widgets/web_nav_bar.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/nav_bar_bloc/nav_bar_bloc.dart';
import '../../utils/app_dialogs.dart';
import '../styles/text_styles_bigger.dart';
import '../widgets/accessibility.dart';
import 'dart:ui';
import 'dart:html' as html;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey bodyKey = GlobalKey();
  GlobalKey mobileAppBarKey = GlobalKey();
  GlobalKey webNavBarKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();
  late NavBarBloc _navBarBloc;
  late RouteControllerBloc _routeControllerBloc;
  late HowToUseBloc _howToUseBloc;
  late FirstStageBloc _firstStageBloc;
  bool residentsBool = false;
  bool bussinessBool = false;
  bool accessibilityFloat = false;
  late AccessibilityControllerState _state;
  Timer? countdownTimer;
  var counter = 5;

  @override
  void initState() {
    super.initState();
    _navBarBloc = BlocProvider.of<NavBarBloc>(context);
    _routeControllerBloc = BlocProvider.of<RouteControllerBloc>(context);
    _howToUseBloc = BlocProvider.of<HowToUseBloc>(context);
    _firstStageBloc = BlocProvider.of<FirstStageBloc>(context);
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
    ticker();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarBloc, NavBarState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppStyle.scaffoldColor,
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
                                  border: Border.all(
                                    color: Colors.white,
                                  )),
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
              appBar: MediaQuery.of(context).size.width > 768
                  ? null
                  : _buildMobileAppBar(),
              body: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SizedBox(
                  key: bodyKey,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: MediaQuery.of(context).size.width > 768
                        ? _buildContent()
                        : _buildMobileContent(),
                  ),
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
    );
  }

  Widget _buildWebAppBar() {
    return SizedBox(
      key: webNavBarKey,
      width: MediaQuery.of(context).size.width,
      height: _state.status == AccessibilityControllerStatus.big
          ? 230
          : _state.status == AccessibilityControllerStatus.biggest
              ? 250
              : 220,
      child: const WebNavBar(),
    );
  }

  Widget _buildMobileContent() {
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
      builder: (context, state) {
        if (state is ResidentsState) {
          return ResidentsScreen(
            routeControllerBloc: _routeControllerBloc,
            firstStageBloc: _firstStageBloc,
          );
        } else if (state is BussinessState) {
          return BussinessScreen(
            routeControllerBloc: _routeControllerBloc,
            firstStageBloc: _firstStageBloc,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 20),
                _buildContentDescription(),
                const SizedBox(height: 20),
                _buildMobileButtons(),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMobileButtons() {
    return Column(
      children: [
        _buildMobileBtn(
          image: Strings.residents,
          title: LocaleKeys.residents.tr().toTitleCase(),
          onEnter: (event) {
            setState(() {
              residentsBool = true;
            });
          },
          onExit: (event) {
            setState(() {
              residentsBool = false;
            });
          },
          isChanged: residentsBool,
          onPress: () {
            _routeControllerBloc.add(OpenResidentsScreenEvent());
          },
        ),
        const SizedBox(height: 20),
        _buildMobileBtn(
          image: Strings.bussiness,
          title: LocaleKeys.economic_entities.tr().toTitleCase(),
          onEnter: (event) {
            setState(() {
              bussinessBool = true;
            });
          },
          onExit: (event) {
            setState(() {
              bussinessBool = false;
            });
          },
          isChanged: bussinessBool,
          onPress: () {
            _routeControllerBloc.add(OpenBussinessScreenEvent());
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildWebAppBar(),
        BlocBuilder<RouteControllerBloc, RouteControllerState>(
          builder: (context, state) {
            if (state is ResidentsState) {
              return ResidentsScreen(
                routeControllerBloc: _routeControllerBloc,
                firstStageBloc: _firstStageBloc,
              );
            } else if (state is BussinessState) {
              return BussinessScreen(
                routeControllerBloc: _routeControllerBloc,
                firstStageBloc: _firstStageBloc,
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildContentDescription(),
                    const SizedBox(height: 20),
                    _buildButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        _buildBtn(
          image: Strings.residents,
          title: LocaleKeys.residents.tr().toTitleCase(),
          onEnter: (event) {
            setState(() {
              residentsBool = true;
            });
          },
          onExit: (event) {
            setState(() {
              residentsBool = false;
            });
          },
          isChanged: residentsBool,
          onPress: () {
            _routeControllerBloc.add(OpenResidentsScreenEvent());
          },
        ),
        const SizedBox(width: 20),
        _buildBtn(
          image: Strings.bussiness,
          title: LocaleKeys.economic_entities.tr().toTitleCase(),
          onEnter: (event) {
            setState(() {
              bussinessBool = true;
            });
          },
          onExit: (event) {
            setState(() {
              bussinessBool = false;
            });
          },
          isChanged: bussinessBool,
          onPress: () {
            _routeControllerBloc.add(OpenBussinessScreenEvent());
          },
        ),
      ],
    );
  }

  Widget _buildMobileBtn({
    required String image,
    required String title,
    required Function(PointerEnterEvent) onEnter,
    required Function(PointerExitEvent) onExit,
    required bool isChanged,
    required Function() onPress,
  }) {
    return GestureDetector(
      onTap: onPress,
      child: MouseRegion(
        onEnter: onEnter,
        onExit: onExit,
        child: Transform.scale(
          scale: isChanged ? 1.02 : 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 125,
            decoration: BoxDecoration(
              color: isChanged
                  ? AppStyle.greenBtnHoover
                  : AppStyle.greenBtnUnHoover,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 190,
                      child: Text(
                        title,
                        style:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.btnMobileText
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.btnMobileText
                                    : TextStyles.btnMobileText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Image.asset(
                      image,
                      width: 65,
                      height: 65,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBtn({
    required String image,
    required String title,
    required Function(PointerEnterEvent) onEnter,
    required Function(PointerExitEvent) onExit,
    required bool isChanged,
    required Function() onPress,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: MouseRegion(
          onEnter: onEnter,
          onExit: onExit,
          child: Transform.scale(
            scale: isChanged ? 1.02 : 1,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: isChanged
                    ? AppStyle.greenBtnHoover
                    : AppStyle.greenBtnUnHoover,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      image,
                      width: 135,
                      height: 135,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      title,
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.btnText
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.btnText
                              : TextStyles.btnText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentDescription() {
    if (MediaQuery.of(context).size.width > 768) {
      return SelectableText(
        'Pavojingųjų atliekų identifikavimo ir klasifikavimo įrankiai parengti Aplinkos ministerijos įgyvendinamo 2014–2021 m. Norvegijos finansinio mechanizmo projekto „HAZ-IDENT“ metu sukurtos vieningos pavojingųjų atliekų identifikavimo metodikos pagrindu. Šios metodikos tikslas valstybės, savivaldos institucijoms ir įstaigoms, ūkio subjektams sudaryti sąlygas teisingai ir vieningai taikyti nacionalinius ir Europos Sąjungos teisės aktus dėl atliekų klasifikavimo. Taip siekiama užtikrinti tinkamą ir efektyvų pavojingųjų atliekų identifikavimą ir klasifikavimą, pavojingųjų atliekų saugų ir efektyvų surinkimą ir tvarkymą.',
        style: _state.status == AccessibilityControllerStatus.big
            ? TextStylesBigger.contentDescription
            : _state.status == AccessibilityControllerStatus.biggest
                ? TextStylesBiggest.contentDescription
                : TextStyles.contentDescription,
        textAlign: TextAlign.justify,
      );
    } else {
      return SelectableText(
        'Pavojingųjų atliekų identifikavimo ir klasifikavimo įrankiai parengti Aplinkos ministerijos įgyvendinamo 2014–2021 m. Norvegijos finansinio mechanizmo projekto „HAZ-IDENT“ metu sukurtos vieningos pavojingųjų atliekų identifikavimo metodikos pagrindu. Šios metodikos tikslas valstybės, savivaldos institucijoms ir įstaigoms, ūkio subjektams sudaryti sąlygas teisingai ir vieningai taikyti nacionalinius ir Europos Sąjungos teisės aktus dėl atliekų klasifikavimo. Taip siekiama užtikrinti tinkamą ir efektyvų pavojingųjų atliekų identifikavimą ir klasifikavimą, pavojingųjų atliekų saugų ir efektyvų surinkimą ir tvarkymą.',
        style: _state.status == AccessibilityControllerStatus.big
            ? TextStylesBigger.mobileContentDescription
            : _state.status == AccessibilityControllerStatus.biggest
                ? TextStylesBiggest.mobileContentDescription
                : TextStyles.mobileContentDescription,
        textAlign: TextAlign.justify,
      );
    }
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return PreferredSize(
      key: mobileAppBarKey,
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        75,
      ),
      child: MobileNavBar(navBarBloc: _navBarBloc),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.nav_description_first.tr(),
          style: _state.status == AccessibilityControllerStatus.big
              ? TextStylesBigger.navigationDescriptionMobileStyle
              : _state.status == AccessibilityControllerStatus.biggest
                  ? TextStylesBigger.navigationDescriptionMobileStyle
                  : TextStyles.navigationDescriptionMobileStyle,
        ),
        Text(
          LocaleKeys.nav_description_second.tr(),
          style: _state.status == AccessibilityControllerStatus.big
              ? TextStylesBigger.navigationSecondDescriptionMobileStyle
              : _state.status == AccessibilityControllerStatus.biggest
                  ? TextStylesBigger.navigationSecondDescriptionMobileStyle
                  : TextStyles.navigationSecondDescriptionMobileStyle,
        ),
      ],
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

  void ticker() {
    Timer.periodic(
      const Duration(milliseconds: 1000),
      (timer) {
        double? renderSize;
        if(MediaQuery.of(context).size.width > 768) {
          renderSize = bodyKey.currentContext!.size!.height + webNavBarKey.currentContext!.size!.height;
        } else {
          renderSize = bodyKey.currentContext!.size!.height + mobileAppBarKey.currentContext!.size!.height;
        }
        int normalInt =
            (renderSize + _scrollController.position.maxScrollExtent).round();
        html.window.parent!.postMessage({'height': normalInt}, '*');
      },
    );
  }
}
