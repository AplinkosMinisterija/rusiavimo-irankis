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
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class WebNavBar extends StatefulWidget {
  const WebNavBar({super.key});

  @override
  State<WebNavBar> createState() => _WebNavBarState();
}

class _WebNavBarState extends State<WebNavBar> {
  String? titleString;
  late FirstStageBloc firstStageBloc;
  late RouteControllerBloc _routeControllerBloc;
  String? trashTitle;
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
            } else if (state is FoundCodeState) {
              trashTitle = state.title;
            } else if (state is CodeFoundAfterThirdStageState) {
              if (state.trashType == 'AP') {
                trashTitle = 'Pavojinga atlieka';
              } else {
                trashTitle = 'Nepavojinga atlieka';
              }
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
      child: Stack(
        children: [
          _buildBg(AppStyle.appBarWebColor),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavigationBar(),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(),
                          _buildRouteTracker(),
                        ],
                      ),
                      // IconButton(onPressed: () {}, icon: Icon()),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteTracker() {
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
      builder: (context, routeState) {
        if (routeState is RouteControllerInitial &&
            ModalRoute.of(context)!.settings.name == '/') {
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
                    _trackerText('Atliekų grupės'),
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
                    _trackerText('Atliekų grupės'),
                    _trackerIcon(),
                    _trackerText('Atliekų pogrupiai'),
                  ],
                );
              } else if (ModalRoute.of(context)!
                      .settings
                      .name!
                      .contains('recomendations/') ||
                  routeState is RouteControllerInitial &&
                      ModalRoute.of(context)!
                          .settings
                          .name!
                          .contains('recomendations/')) {
                List<String> routeStringsList =
                    ModalRoute.of(context)!.settings.name!.split('/');
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
                      child: _trackerText(routeStringsList[2]),
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
                    _trackerText('Specifinės atliekų grupės'),
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
        } else if (ModalRoute.of(context)!
                .settings
                .name!
                .contains('recomendations/') ||
            routeState is RouteControllerInitial &&
                ModalRoute.of(context)!
                    .settings
                    .name!
                    .contains('recomendations/') ||
            ModalRoute.of(context)!.settings.name!.contains('final/') ||
            routeState is RouteControllerInitial &&
                ModalRoute.of(context)!.settings.name!.contains('final/')) {
          List<String> routeStringsList =
              ModalRoute.of(context)!.settings.name!.split('/');
          String? trashTitleFromUri;
          try {
            trashTitleFromUri = Uri.decodeFull(routeStringsList[2]);
          } catch (e) {
            trashTitleFromUri = routeStringsList[2];
          }
          return Row(
            children: [
              _trackerText(LocaleKeys.home.tr().toTitleCase()),
              _trackerIcon(),
              _trackerText(LocaleKeys.economic_entities.tr().toTitleCase()),
              _trackerIcon(),
              _trackerText('Atliekos kodo parinkimas'),
              _trackerIcon(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: _trackerText(trashTitleFromUri!),
              ),
            ],
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
        if (routeState is RouteControllerInitial &&
            !ModalRoute.of(context)!
                .settings
                .name!
                .contains('recomendations/') &&
            !ModalRoute.of(context)!.settings.name!.contains('final/')) {
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
                LocaleKeys.nav_description_second.tr(),
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
              } else if (ModalRoute.of(context)!
                      .settings
                      .name!
                      .contains('recomendations/') ||
                  ModalRoute.of(context)!.settings.name!.contains('final/')) {
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
        } else if (ModalRoute.of(context)!
                .settings
                .name!
                .contains('recomendations/') ||
            ModalRoute.of(context)!.settings.name!.contains('final/')) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Rūšiavimo ir tvarkymo ',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationDescriptionStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationDescriptionStyle
                            : TextStyles.navigationDescriptionStyle,
                  ),
                  TextSpan(
                    text: 'rekomendacijos',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationSecondDescriptionStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationSecondDescriptionStyle
                            : TextStyles.navigationSecondDescriptionStyle,
                  ),
                ],
              ),
              maxLines: 1,
              minFontSize: 5,
            ),
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
                  color: AppStyle.black,
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
              onPressed: () async {
                Navigator.pushReplacementNamed(context, "/");
                _routeControllerBloc.add(OpenHomeScreenEvent());
                if (firstStageBloc.state is FirstStageInitial) {
                } else {
                  firstStageBloc.add(BackToInitialEvent());
                }
              },
              child: Text(
                LocaleKeys.home.tr().toUpperCase(),
                style: (routeState is RouteControllerInitial &&
                            ModalRoute.of(context)!
                                .settings
                                .name!
                                .contains('recomendations/') ||
                        routeState is RouteControllerInitial &&
                            ModalRoute.of(context)!
                                .settings
                                .name!
                                .contains('final/'))
                    ? _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationBtnUnSelectedStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationBtnUnSelectedStyle
                            : TextStyles.navigationBtnUnSelectedStyle
                    : (routeState is RouteControllerInitial &&
                            ModalRoute.of(context)!
                                .settings
                                .name!
                                .contains('/'))
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
            const SizedBox(width: 40),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/");
                _routeControllerBloc.add(OpenResidentsScreenEvent());
                if (firstStageBloc.state is FirstStageInitial) {
                } else {
                  firstStageBloc.add(BackToInitialEvent());
                }
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
                Navigator.pushReplacementNamed(context, "/");
                _routeControllerBloc.add(OpenBussinessScreenEvent());
                if (firstStageBloc.state is FirstStageInitial) {
                } else {
                  firstStageBloc.add(BackToInitialEvent());
                }
              },
              child: Text(
                LocaleKeys.economic_entities.tr().toUpperCase(),
                style: (_routeControllerBloc.state is BussinessState)
                    ? _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.navigationBtnSelectedStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.navigationBtnSelectedStyle
                            : TextStyles.navigationBtnSelectedStyle
                    : (ModalRoute.of(context)!
                                .settings
                                .name!
                                .contains('recomendations/') ||
                            ModalRoute.of(context)!
                                .settings
                                .name!
                                .contains('final/'))
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
            color: AppStyle.blackBgWithOpacity,
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
    );
  }
}
