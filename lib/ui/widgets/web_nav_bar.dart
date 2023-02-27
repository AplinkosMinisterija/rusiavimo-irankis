import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../../constants/strings.dart';
import '../styles/text_styles.dart';

class WebNavBar extends StatefulWidget {
  final HowToUseBloc howToUseBloc;

  const WebNavBar({
    super.key,
    required this.howToUseBloc,
  });

  @override
  State<WebNavBar> createState() => _WebNavBarState();
}

class _WebNavBarState extends State<WebNavBar> {
  String? titleString;
  late FirstStageBloc firstStageBloc;
  late RouteControllerBloc _routeControllerBloc;
  String? trashTitle;

  @override
  void initState() {
    super.initState();
    firstStageBloc = BlocProvider.of<FirstStageBloc>(context);
    _routeControllerBloc = BlocProvider.of<RouteControllerBloc>(context);
  }

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
                  BlocConsumer<FirstStageBloc, FirstStageState>(
                    listener: (context, state) {
                      if (state is SecondStageOpenState) {
                        titleString = state.category.title;
                      } else if (state is FoundCodeState) {
                        trashTitle = state.title;
                      } else if (state is CodeFoundAfterThirdStageState) {
                        trashTitle = state.trashTitle;
                      }
                    },
                    builder: (context, state) {
                      if (state is FirstStageOpenState ||
                          state is FirstStageLoadingState ||
                          state is SelectedCategoryState ||
                          state is SecondStageLoadingState ||
                          state is SecondStageOpenState ||
                          state is ThirdStageOpenState ||
                          state is ThirdStageLoadingState) {
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
      onPressed: () {
        widget.howToUseBloc.add(OpenHowToUseEvent());
      },
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
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
      builder: (context, routeState) {
        if (routeState is RouteControllerInitial) {
          return Row(
            children: [
              _trackerText(LocaleKeys.home.tr().toTitleCase()),
            ],
          );
        } else if (routeState is ResidentsState) {
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
        } else if (routeState is BussinessState) {
          return BlocBuilder<FirstStageBloc, FirstStageState>(
            builder: (context, state) {
              if (state is FirstStageOpenState ||
                  state is FirstStageLoadingState) {
                return Row(
                  children: [
                    _trackerText(LocaleKeys.home.tr().toTitleCase()),
                    _trackerIcon(),
                    _trackerText(
                        LocaleKeys.economic_entities.tr().toTitleCase()),
                    _trackerIcon(),
                    _trackerText('Atliekos kodo parinkimas'),
                    _trackerIcon(),
                    _trackerText('Atliekų kategorijos'),
                  ],
                );
              } else if (state is SelectedCategoryState) {
                return Row(
                  children: [
                    _trackerText(LocaleKeys.home.tr().toTitleCase()),
                    _trackerIcon(),
                    _trackerText(
                        LocaleKeys.economic_entities.tr().toTitleCase()),
                    _trackerIcon(),
                    _trackerText('Atliekos kodo parinkimas'),
                    _trackerIcon(),
                    _trackerText('Atliekų kategorijos'),
                    _trackerIcon(),
                    _trackerText('Atliekų subkategorijos'),
                  ],
                );
              } else if (state is FoundCodeState ||
                  state is CodeFoundAfterThirdStageState) {
                return Row(
                  children: [
                    _trackerText(LocaleKeys.home.tr().toTitleCase()),
                    _trackerIcon(),
                    _trackerText(
                        LocaleKeys.economic_entities.tr().toTitleCase()),
                    _trackerIcon(),
                    _trackerText('Atliekos kodo parinkimas'),
                    _trackerIcon(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: _trackerText(trashTitle!),
                    ),
                  ],
                );
              } else if (state is SecondStageLoadingState ||
                  state is SecondStageOpenState) {
                return Row(
                  children: [
                    _trackerText('...'),
                    _trackerIcon(),
                    _trackerText('Atliekų sąrašas'),
                    _trackerIcon(),
                    _trackerText('Specifinės atliekų kategorijos'),
                    _trackerIcon(),
                    _trackerText((titleString != null) ? titleString! : ''),
                  ],
                );
              } else if (state is ThirdStageLoadingState ||
                  state is ThirdStageOpenState) {
                return Row(
                  children: [
                    _trackerText('...'),
                    _trackerIcon(),
                    _trackerText((titleString != null) ? titleString! : ''),
                    _trackerIcon(),
                    _trackerText('Pavojingumo įvertinimas'),
                  ],
                );
              } else {
                return Row(
                  children: [
                    _trackerText(LocaleKeys.home.tr().toTitleCase()),
                    _trackerIcon(),
                    _trackerText(
                        LocaleKeys.economic_entities.tr().toTitleCase()),
                  ],
                );
              }
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildTitle() {
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
      builder: (context, routeState) {
        if (routeState is RouteControllerInitial) {
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
        } else if (routeState is ResidentsState) {
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
        } else if (routeState is BussinessState) {
          return BlocBuilder<FirstStageBloc, FirstStageState>(
            builder: (context, state) {
              if (state is FirstStageOpenState ||
                  state is SelectedCategoryState ||
                  state is FirstStageLoadingState) {
                return Row(
                  children: const [
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
              } else if (state is FoundCodeState ||
                  state is CodeFoundAfterThirdStageState) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Rūšiavimo ir tvarkymo ',
                          style: TextStyles.navigationDescriptionStyle,
                        ),
                        TextSpan(
                          text: 'rekomendacijos',
                          style: TextStyles.navigationSecondDescriptionStyle,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    minFontSize: 5,
                  ),
                );
              } else if (state is SecondStageLoadingState ||
                  state is SecondStageOpenState) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.77,
                  child: const AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Specifinių kategorijų atliekų ',
                          style: TextStyles.navigationDescriptionStyle,
                        ),
                        TextSpan(
                          text: 'identifikavimas',
                          style: TextStyles.navigationSecondDescriptionStyle,
                        )
                      ],
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                );
              } else if (state is ThirdStageOpenState ||
                  state is ThirdStageLoadingState) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.77,
                  child: const AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Atliekų pavojingumo ',
                          style: TextStyles.navigationDescriptionStyle,
                        ),
                        TextSpan(
                          text: 'įvertinimas',
                          style: TextStyles.navigationSecondDescriptionStyle,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
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
      },
    );
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
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
      builder: (context, routeState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 30),
            TextButton(
              onPressed: (routeState is RouteControllerInitial)
                  ? () {}
                  : () {
                      _routeControllerBloc.add(OpenHomeScreenEvent());
                      if (firstStageBloc.state is FirstStageInitial) {
                      } else {
                        firstStageBloc.add(BackToInitialEvent());
                      }
                    },
              child: Text(
                LocaleKeys.home.tr().toUpperCase(),
                style: (routeState is RouteControllerInitial)
                    ? TextStyles.navigationBtnSelectedStyle
                    : TextStyles.navigationBtnUnSelectedStyle,
              ),
            ),
            const SizedBox(width: 40),
            TextButton(
              onPressed: (routeState is ResidentsState)
                  ? () {}
                  : () {
                      _routeControllerBloc.add(OpenResidentsScreenEvent());
                      if (firstStageBloc.state is FirstStageInitial) {
                      } else {
                        firstStageBloc.add(BackToInitialEvent());
                      }
                    },
              child: Text(
                LocaleKeys.residents.tr().toUpperCase(),
                style: (routeState is ResidentsState)
                    ? TextStyles.navigationBtnSelectedStyle
                    : TextStyles.navigationBtnUnSelectedStyle,
              ),
            ),
            const SizedBox(width: 40),
            TextButton(
              onPressed: (routeState is BussinessState)
                  ? () {}
                  : () {
                      _routeControllerBloc.add(OpenBussinessScreenEvent());
                      if (firstStageBloc.state is FirstStageInitial) {
                      } else {
                        firstStageBloc.add(BackToInitialEvent());
                      }
                    },
              child: Text(
                LocaleKeys.economic_entities.tr().toUpperCase(),
                style: (_routeControllerBloc.state is BussinessState)
                    ? TextStyles.navigationBtnSelectedStyle
                    : TextStyles.navigationBtnUnSelectedStyle,
              ),
            ),
          ],
        );
      },
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

  Widget _trackerText(String title) {
    return Text(
      title,
      style: TextStyles.routeTracker,
    );
  }
}
