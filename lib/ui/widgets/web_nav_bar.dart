import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../../constants/strings.dart';
import '../styles/text_styles.dart';

class WebNavBar extends StatefulWidget {
  const WebNavBar({super.key});

  @override
  State<WebNavBar> createState() => _WebNavBarState();
}

class _WebNavBarState extends State<WebNavBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBg(AppColors.appBarWebColor),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          child: Column(
            children: [
              _buildNavigationBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      _buildRouteTracker(),
                    ],
                  ),
                  BlocBuilder<FirstStageBloc, FirstStageState>(
                    builder: (context, state) {
                      if (state is FirstStageOpenState) {
                        return _buildHowToUseTool();
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHowToUseTool() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.appBarWebColor,
        elevation: 0,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.help,
            color: AppColors.helpIconColor,
            size: 48,
          ),
          const SizedBox(height: 10),
          Text(
            'Kaip naudotis įrankiu?',
            style: TextStyles.routeTracker
                .copyWith(color: AppColors.black.withOpacity(0.55)),
          )
        ],
      ),
    );
  }

  Widget _buildRouteTracker() {
    if (ModalRoute.of(context)!.settings.name == RouteName.main_route) {
      return Row(
        children: [
          _trackerText(LocaleKeys.home.tr().toTitleCase()),
        ],
      );
    } else if (ModalRoute.of(context)!.settings.name ==
        RouteName.residents_route) {
      return Row(
        children: [
          _trackerText(LocaleKeys.home.tr().toTitleCase()),
          _trackerIcon(),
          _trackerText(LocaleKeys.residents.tr().toTitleCase()),
          _trackerIcon(),
          _trackerText(
              '${LocaleKeys.nav_second_page_desc.tr()}${LocaleKeys.nav_second_page_desc2.tr()}'),
        ],
      );
    } else if (ModalRoute.of(context)!.settings.name ==
        RouteName.bussiness_route) {
      return BlocBuilder<FirstStageBloc, FirstStageState>(
        builder: (context, state) {
          if (state is FirstStageOpenState) {
            return Row(
              children: [
                _trackerText(LocaleKeys.home.tr().toTitleCase()),
                _trackerIcon(),
                _trackerText(LocaleKeys.economic_entities.tr().toTitleCase()),
                _trackerIcon(),
                _trackerText('Atliekos kodo parinkimas'),
                _trackerIcon(),
                _trackerText('Atliekų kategorijos'),
              ],
            );
          } else {
            return Row(
              children: [
                _trackerText(LocaleKeys.home.tr().toTitleCase()),
                _trackerIcon(),
                _trackerText(LocaleKeys.economic_entities.tr().toTitleCase()),
              ],
            );
          }
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildTitle() {
    if (ModalRoute.of(context)!.settings.name == RouteName.main_route) {
      return Row(
        children: [
          Text(
            LocaleKeys.nav_description_first.tr(),
            style: TextStyles.navigationDescriptionStyle,
          ),
          Text(
            LocaleKeys.nav_description_second.tr(),
            style: TextStyles.navigationSecondDescriptionStyle,
          ),
        ],
      );
    } else if (ModalRoute.of(context)!.settings.name ==
        RouteName.residents_route) {
      return Row(
        children: [
          Text(
            LocaleKeys.nav_second_page_desc.tr(),
            style: TextStyles.navigationDescriptionStyle,
          ),
          Text(
            LocaleKeys.nav_second_page_desc2.tr(),
            style: TextStyles.navigationSecondDescriptionStyle,
          ),
        ],
      );
    } else if (ModalRoute.of(context)!.settings.name ==
        RouteName.bussiness_route) {
      return BlocBuilder<FirstStageBloc, FirstStageState>(
        builder: (context, state) {
          if (state is FirstStageOpenState) {
            return Row(
              children: [
                Text(
                  'Atliekos kodo ',
                  style: TextStyles.navigationDescriptionStyle,
                ),
                Text(
                  'parinkimas',
                  style: TextStyles.navigationSecondDescriptionStyle,
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Text(
                  LocaleKeys.nav_bussiness_page_desc.tr(),
                  style: TextStyles.navigationDescriptionStyle,
                ),
                Text(
                  LocaleKeys.nav_bussiness_page_desc2.tr(),
                  style: TextStyles.navigationSecondDescriptionStyle,
                ),
              ],
            );
          }
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildBg(Color color) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: color,
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.03,
      ),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Strings.logo,
              width: 188,
              height: 85,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNav(),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: AppColors.black,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 30),
        TextButton(
          onPressed:
              (ModalRoute.of(context)!.settings.name == RouteName.main_route)
                  ? () {}
                  : () {
                      Navigator.of(context).pushNamed(RouteName.main_route);
                    },
          child: Text(
            LocaleKeys.home.tr().toUpperCase(),
            style:
                (ModalRoute.of(context)!.settings.name == RouteName.main_route)
                    ? TextStyles.navigationBtnSelectedStyle
                    : TextStyles.navigationBtnUnSelectedStyle,
          ),
        ),
        const SizedBox(width: 40),
        TextButton(
          onPressed: (ModalRoute.of(context)!.settings.name ==
                  RouteName.residents_route)
              ? () {}
              : () {
                  Navigator.of(context).pushNamed(RouteName.residents_route);
                },
          child: Text(
            LocaleKeys.residents.tr().toUpperCase(),
            style: (ModalRoute.of(context)!.settings.name ==
                    RouteName.residents_route)
                ? TextStyles.navigationBtnSelectedStyle
                : TextStyles.navigationBtnUnSelectedStyle,
          ),
        ),
        const SizedBox(width: 40),
        TextButton(
          onPressed: (ModalRoute.of(context)!.settings.name ==
                  RouteName.bussiness_route)
              ? () {}
              : () {
                  Navigator.of(context).pushNamed(RouteName.bussiness_route);
                },
          child: Text(
            LocaleKeys.economic_entities.tr().toUpperCase(),
            style: (ModalRoute.of(context)!.settings.name ==
                    RouteName.bussiness_route)
                ? TextStyles.navigationBtnSelectedStyle
                : TextStyles.navigationBtnUnSelectedStyle,
          ),
        ),
      ],
    );
  }

  Row _trackerIcon() {
    return Row(
      children: const [
        SizedBox(width: 10),
        Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(
            Icons.play_arrow,
            color: AppColors.blackBgWithOpacity,
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Text _trackerText(String title) {
    return Text(
      title,
      style: TextStyles.routeTracker,
    );
  }
}
