import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/nav_bar_bloc/nav_bar_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../../generated/locale_keys.g.dart';
import '../styles/text_styles.dart';

class ExtendedMobileNavBar extends StatefulWidget {
  final NavBarBloc navBarBloc;

  const ExtendedMobileNavBar({
    super.key,
    required this.navBarBloc,
  });

  @override
  State<ExtendedMobileNavBar> createState() => _ExtendedMobileNavBarState();
}

class _ExtendedMobileNavBarState extends State<ExtendedMobileNavBar> {
  late RouteControllerBloc _routeControllerBloc;

  @override
  void initState() {
    super.initState();
    _routeControllerBloc = BlocProvider.of<RouteControllerBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                onPressed: (state is RouteControllerInitial)
                    ? () {}
                    : () {
                  _routeControllerBloc.add(OpenHomeScreenEvent());
                  widget.navBarBloc.add(CloseNavBarEvent());
                      },
                child: Text(
                  LocaleKeys.home.tr().toUpperCase(),
                  style: (state is RouteControllerInitial)
                      ? TextStyles.navigationBtnSelectedStyle
                      : TextStyles.navigationBtnUnSelectedStyle,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: (state is ResidentsState)
                    ? () {}
                    : () {
                  _routeControllerBloc.add(OpenResidentsScreenEvent());
                  widget.navBarBloc.add(CloseNavBarEvent());
                      },
                child: Text(
                  LocaleKeys.residents.tr().toUpperCase(),
                  style: (state is ResidentsState)
                      ? TextStyles.navigationBtnSelectedStyle
                      : TextStyles.navigationBtnUnSelectedStyle,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: (state is BussinessState)
                    ? () {}
                    : () {
                  _routeControllerBloc.add(OpenBussinessScreenEvent());
                  widget.navBarBloc.add(CloseNavBarEvent());
                      },
                child: Text(
                  LocaleKeys.economic_entities.tr().toUpperCase(),
                  style: (state is BussinessState)
                      ? TextStyles.navigationBtnSelectedStyle
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
                TextButton(
                  onPressed: () {
                    // if (context.locale.languageCode == 'en') {
                    //   _changeLocale(const Locale('lt'));
                    // } else {
                    //   _changeLocale(const Locale('en'));
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      context.locale.languageCode == 'en'
                          ? LocaleKeys.lt.tr()
                          : LocaleKeys.en.tr(),
                      style: TextStyles.languageBtnStyle,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.phone),
                ),
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
        color: AppColors.dividerColor,
      ),
    ];
  }

  void _changeLocale(Locale? locale) async {
    await context.setLocale(locale!);
    widget.navBarBloc.add(CloseNavBarEvent());
  }
}
