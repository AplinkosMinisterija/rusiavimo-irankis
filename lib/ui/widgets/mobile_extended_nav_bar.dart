import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/nav_bar_bloc/nav_bar_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../../generated/locale_keys.g.dart';
import '../../utils/app_dialogs.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import 'accessibility.dart';

class ExtendedMobileNavBar extends StatefulWidget {
  final NavBarBloc navBarBloc;
  final FirstStageBloc firstStageBloc;
  final Function()? onAccessibilityPress;

  const ExtendedMobileNavBar({
    super.key,
    required this.navBarBloc,
    required this.firstStageBloc,
    required this.onAccessibilityPress,
  });

  @override
  State<ExtendedMobileNavBar> createState() => _ExtendedMobileNavBarState();
}

class _ExtendedMobileNavBarState extends State<ExtendedMobileNavBar> {
  late RouteControllerBloc _routeControllerBloc;
  late AccessibilityControllerState _state;

  @override
  void initState() {
    super.initState();
    _routeControllerBloc = BlocProvider.of<RouteControllerBloc>(context);
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
      child: Positioned(
        right: 0,
        top: 0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: firstPart(),
                  ),
                ),
                ...secondPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> secondPart() {
    return [
      BlocBuilder<RouteControllerBloc, RouteControllerState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/");
                  _routeControllerBloc.add(OpenHomeScreenEvent());
                  if (widget.firstStageBloc.state is FirstStageInitial) {
                  } else {
                    widget.firstStageBloc.add(BackToInitialEvent());
                  }
                  widget.navBarBloc.add(CloseNavBarEvent());
                },
                child: Text(
                  LocaleKeys.home.tr().toUpperCase(),
                  style: (state is RouteControllerInitial)
                      ? _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationBtnSelectedStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.navigationBtnSelectedStyle
                              : TextStyles.navigationBtnSelectedStyle
                      : _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationBtnUnSelectedStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.navigationBtnUnSelectedStyle
                              : TextStyles.navigationBtnUnSelectedStyle,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/");
                  _routeControllerBloc.add(OpenResidentsScreenEvent());
                  if (widget.firstStageBloc.state is FirstStageInitial) {
                  } else {
                    widget.firstStageBloc.add(BackToInitialEvent());
                  }
                  widget.navBarBloc.add(CloseNavBarEvent());
                },
                child: Text(
                  LocaleKeys.residents.tr().toUpperCase(),
                  style: (state is ResidentsState)
                      ? _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationBtnSelectedStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.navigationBtnSelectedStyle
                              : TextStyles.navigationBtnSelectedStyle
                      : _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationBtnUnSelectedStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.navigationBtnUnSelectedStyle
                              : TextStyles.navigationBtnUnSelectedStyle,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/");
                  _routeControllerBloc.add(OpenBussinessScreenEvent());
                  if (widget.firstStageBloc.state is FirstStageInitial) {
                  } else {
                    widget.firstStageBloc.add(BackToInitialEvent());
                  }
                  widget.navBarBloc.add(CloseNavBarEvent());
                },
                child: Text(
                  LocaleKeys.economic_entities.tr().toUpperCase(),
                  style: (state is BussinessState)
                      ? _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationBtnSelectedStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.navigationBtnSelectedStyle
                              : TextStyles.navigationBtnSelectedStyle
                      : _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationBtnUnSelectedStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.navigationBtnUnSelectedStyle
                              : TextStyles.navigationBtnUnSelectedStyle,
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    ];
  }

  List<Widget> firstPart() {
    return [
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onAccessibilityPress,
                  icon: const Icon(
                    Icons.accessibility,
                    color: Colors.black,
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.phone),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  widget.navBarBloc.add(CloseNavBarEvent());
                },
                icon: const Icon(Icons.menu),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 5),
      const Divider(
        height: 1,
        color: AppStyle.dividerColor,
      ),
    ];
  }

  void _changeLocale(Locale? locale) async {
    await context.setLocale(locale!);
    widget.navBarBloc.add(CloseNavBarEvent());
  }
}
