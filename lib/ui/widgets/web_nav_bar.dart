import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../../constants/strings.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import 'dart:html' as html;


class WebNavBar extends StatefulWidget {
  const WebNavBar({super.key});

  @override
  State<WebNavBar> createState() => _WebNavBarState();
}

class _WebNavBarState extends State<WebNavBar> {
  String? titleString;
  late FirstStageBloc firstStageBloc;
  late RouteControllerBloc _routeControllerBloc;
  late AccessibilityControllerState _state;

  @override
  void initState() {
    super.initState();
    firstStageBloc = BlocProvider.of<FirstStageBloc>(context);
    _routeControllerBloc = BlocProvider.of<RouteControllerBloc>(context);
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FirstStageBloc, FirstStageState>(
          listener: (context, state) {
            if (state is SecondStageOpenState) {
              titleString = state.category.title;
            }
          },
        ),
        BlocListener<AccessibilityControllerCubit,
            AccessibilityControllerState>(
          listener: (context, state) {
            _state = state;
            setState(() {});
          },
        ),
      ],
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColors.appBarWebColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          child: Column(
            children: [
              _buildNavigationBar(),
              const SizedBox(height: 10),
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
                  // builder: (context, state) {
                  //   if (state is FirstStageOpenState ||
                  //       state is FirstStageLoadingState ||
                  //       state is SelectedCategoryState ||
                  //       state is SecondStageLoadingState ||
                  //       state is SecondStageOpenState ||
                  //       state is ThirdStageOpenState ||
                  //       state is ThirdStageLoadingState) {
                  //     return _buildHowToUseTool();
                  //   } else {
                  //     return const SizedBox();
                  //   }
                  // },
                ],
              ),
            ],
          ),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
              } else if (state is FoundCodeState) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: _trackerText(state.title),
                    ),
                  ],
                );
              } else if (state is CodeFoundAfterThirdStageState) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: _trackerText(state.trashType),
                    ),
                  ],
                );
              } else if (state is SecondStageLoadingState ||
                  state is SecondStageOpenState) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _trackerText('...'),
                    _trackerIcon(),
                    _trackerText((titleString != null) ? titleString! : 'III etapas'),
                    _trackerIcon(),
                    _trackerText('Pavojingumo įvertinimas'),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.navigationDescriptionStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.navigationDescriptionStyle
                        : TextStyles.navigationDescriptionStyle,
              ),
              Text(
                'identifikavimas ir klasifikavimas',
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.navigationSecondDescriptionStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.navigationSecondDescriptionStyle
                        : TextStyles.navigationSecondDescriptionStyle,
              ),
            ],
          );
        } else if (routeState is ResidentsState) {
          return Row(
            children: [
              Text(
                LocaleKeys.nav_second_page_desc.tr(),
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.navigationDescriptionStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.navigationDescriptionStyle
                        : TextStyles.navigationDescriptionStyle,
              ),
              Text(
                LocaleKeys.nav_second_page_desc2.tr(),
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.navigationSecondDescriptionStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.navigationSecondDescriptionStyle
                        : TextStyles.navigationSecondDescriptionStyle,
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
                  children: [
                    Text(
                      'Atliekos kodo ',
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationDescriptionStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.navigationDescriptionStyle
                              : TextStyles.navigationDescriptionStyle,
                    ),
                    Text(
                      'parinkimas',
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationSecondDescriptionStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest
                                  .navigationSecondDescriptionStyle
                              : TextStyles.navigationSecondDescriptionStyle,
                    ),
                  ],
                );
              } else if (state is FoundCodeState ||
                  state is CodeFoundAfterThirdStageState) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Rūšiavimo ir tvarkymo ',
                          style: _state.status ==
                                  AccessibilityControllerStatus.big
                              ? TextStylesBigger.navigationDescriptionStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.navigationDescriptionStyle
                                  : TextStyles.navigationDescriptionStyle,
                        ),
                        TextSpan(
                          text: 'rekomendacijos',
                          style: _state.status ==
                                  AccessibilityControllerStatus.big
                              ? TextStylesBigger
                                  .navigationSecondDescriptionStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest
                                      .navigationSecondDescriptionStyle
                                  : TextStyles.navigationSecondDescriptionStyle,
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
                  child: AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Specifinių kategorijų atliekų ',
                          style: _state.status ==
                                  AccessibilityControllerStatus.big
                              ? TextStylesBigger.navigationDescriptionStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.navigationDescriptionStyle
                                  : TextStyles.navigationDescriptionStyle,
                        ),
                        TextSpan(
                          text: 'identifikavimas',
                          style: _state.status ==
                                  AccessibilityControllerStatus.big
                              ? TextStylesBigger
                                  .navigationSecondDescriptionStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest
                                      .navigationSecondDescriptionStyle
                                  : TextStyles.navigationSecondDescriptionStyle,
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
                  child: AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Atliekų pavojingumo ',
                          style: _state.status ==
                                  AccessibilityControllerStatus.big
                              ? TextStylesBigger.navigationDescriptionStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.navigationDescriptionStyle
                                  : TextStyles.navigationDescriptionStyle,
                        ),
                        TextSpan(
                          text: 'įvertinimas',
                          style: _state.status ==
                                  AccessibilityControllerStatus.big
                              ? TextStylesBigger
                                  .navigationSecondDescriptionStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest
                                      .navigationSecondDescriptionStyle
                                  : TextStyles.navigationSecondDescriptionStyle,
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
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationDescriptionStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.navigationDescriptionStyle
                              : TextStyles.navigationDescriptionStyle,
                    ),
                    Text(
                      LocaleKeys.nav_bussiness_page_desc2.tr(),
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.navigationSecondDescriptionStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest
                                  .navigationSecondDescriptionStyle
                              : TextStyles.navigationSecondDescriptionStyle,
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

  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              (_state.blindness == AccessibilityControllerBlindness.blind)
                  ? Strings.logo_monochrome
                  : Strings.logo,
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
              onPressed: () {
                _routeControllerBloc.add(OpenHomeScreenEvent());
                if (firstStageBloc.state is FirstStageInitial) {
                } else {
                  firstStageBloc.add(BackToInitialEvent());
                }
                html.window.parent!.postMessage({'goUp': true}, '*');
              },
              child: Text(
                LocaleKeys.home.tr().toUpperCase(),
                style: (routeState is RouteControllerInitial)
                    ? _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationBtnSelectedStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationBtnSelectedStyle
                            : TextStyles.navigationBtnSelectedStyle
                    : _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationBtnUnSelectedStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationBtnUnSelectedStyle
                            : TextStyles.navigationBtnUnSelectedStyle,
              ),
            ),
            const SizedBox(width: 40),
            TextButton(
              onPressed: () {
                _routeControllerBloc.add(OpenResidentsScreenEvent());
                if (firstStageBloc.state is FirstStageInitial) {
                } else {
                  firstStageBloc.add(BackToInitialEvent());
                }
                html.window.parent!.postMessage({'goUp': true}, '*');
              },
              child: Text(
                LocaleKeys.residents.tr().toUpperCase(),
                style: (routeState is ResidentsState)
                    ? _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationBtnSelectedStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationBtnSelectedStyle
                            : TextStyles.navigationBtnSelectedStyle
                    : _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationBtnUnSelectedStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationBtnUnSelectedStyle
                            : TextStyles.navigationBtnUnSelectedStyle,
              ),
            ),
            const SizedBox(width: 40),
            TextButton(
              onPressed: () {
                _routeControllerBloc.add(OpenBussinessScreenEvent());
                if (firstStageBloc.state is FirstStageInitial) {
                } else {
                  firstStageBloc.add(BackToInitialEvent());
                }
                html.window.parent!.postMessage({'goUp': true}, '*');
              },
              child: Text(
                LocaleKeys.economic_entities.tr().toUpperCase(),
                style: (_routeControllerBloc.state is BussinessState)
                    ? _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationBtnSelectedStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationBtnSelectedStyle
                            : TextStyles.navigationBtnSelectedStyle
                    : _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationBtnUnSelectedStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationBtnUnSelectedStyle
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
      style: _state.status == AccessibilityControllerStatus.big
          ? TextStylesBigger.routeTracker
          : _state.status == AccessibilityControllerStatus.biggest
              ? TextStylesBiggest.routeTracker
              : TextStyles.routeTracker,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
