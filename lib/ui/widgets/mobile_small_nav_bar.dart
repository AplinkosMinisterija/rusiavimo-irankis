import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/route_controller/route_controller_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../generated/locale_keys.g.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class MobileSmallNavBar extends StatefulWidget {
  final RouteControllerBloc routeControllerBloc;
  String? titleFirstPart;
  String? titleSecondPart;
  final FirstStageBloc firstStageBloc;

  MobileSmallNavBar({
    Key? key,
    required this.routeControllerBloc,
    this.titleFirstPart,
    this.titleSecondPart,
    required this.firstStageBloc,
  }) : super(key: key);

  @override
  State<MobileSmallNavBar> createState() => _MobileSmallNavBarState();
}

class _MobileSmallNavBarState extends State<MobileSmallNavBar> {
  late AccessibilityControllerState _state;

  @override
  void initState() {
    super.initState();
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
      child: BlocBuilder<RouteControllerBloc, RouteControllerState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    _buildSmallNavBtn(
                      title: LocaleKeys.residents.tr().toTitleCase(),
                      isMarked: state is ResidentsState ? true : false,
                      onClick: () {
                        widget.routeControllerBloc
                            .add(OpenResidentsScreenEvent());
                        widget.firstStageBloc.add(BackToInitialEvent());
                      },
                    ),
                    _buildSmallNavBtn(
                      title: LocaleKeys.economic_entities.tr().toCapitalized(),
                      isMarked: state is BussinessState ? true : false,
                      onClick: () {
                        widget.routeControllerBloc
                            .add(OpenBussinessScreenEvent());
                        widget.firstStageBloc.add(BackToInitialEvent());
                      },
                    ),
                  ],
                ),
              ),
              _buildTitle(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSmallNavBtn({
    required String title,
    required Function() onClick,
    required bool isMarked,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isMarked ? AppStyle.scaffoldColor : AppStyle.appBarWebColor,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                title,
                style: isMarked
                    ? _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.smallNavBarStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.smallNavBarStyle
                            : TextStyles.smallNavBarStyle
                    : _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.smallNavBarStyle
                            .copyWith(color: AppStyle.black.withOpacity(0.1))
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.smallNavBarStyle.copyWith(
                                color: AppStyle.black.withOpacity(0.1))
                            : TextStyles.smallNavBarStyle.copyWith(
                                color: AppStyle.black.withOpacity(0.1)),
                textAlign: TextAlign.center,
                maxFontSize: 15,
                minFontSize: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<RouteControllerBloc, RouteControllerState>(
        builder: (context, routeState) {
          if (widget.titleFirstPart != null && widget.titleSecondPart != null) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.titleFirstPart,
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.smallNavTitleStyle
                          : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.smallNavTitleStyle
                          : TextStyles.smallNavTitleStyle,
                    ),
                    TextSpan(
                      text: widget.titleSecondPart,
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.smallNavTitleSecondStyle
                          : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.smallNavTitleSecondStyle
                          : TextStyles.smallNavTitleSecondStyle,
                    ),
                  ],
                ),
              ),
            );
          } else {
            if (routeState is RouteControllerInitial) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: LocaleKeys.nav_description_first.tr(),
                        style: _state.status == AccessibilityControllerStatus.big
                            ? TextStylesBigger.smallNavTitleStyle
                            : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.smallNavTitleStyle
                            : TextStyles.smallNavTitleStyle,
                      ),
                      TextSpan(
                        text: LocaleKeys.nav_description_second.tr(),
                        style: _state.status == AccessibilityControllerStatus.big
                            ? TextStylesBigger.smallNavTitleSecondStyle
                            : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.smallNavTitleSecondStyle
                            : TextStyles.smallNavTitleSecondStyle,
                      ),
                    ],
                  ),
                ),
              );
            } else if (routeState is ResidentsState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: LocaleKeys.nav_second_page_desc.tr(),
                        style: _state.status == AccessibilityControllerStatus.big
                            ? TextStylesBigger.smallNavTitleStyle
                            : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.smallNavTitleStyle
                            : TextStyles.smallNavTitleStyle,
                      ),
                      TextSpan(
                        text: LocaleKeys.nav_second_page_desc2.tr(),
                        style: _state.status == AccessibilityControllerStatus.big
                            ? TextStylesBigger.smallNavTitleSecondStyle
                            : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.smallNavTitleSecondStyle
                            : TextStyles.smallNavTitleSecondStyle,
                      ),
                    ],
                  ),
                ),
              );
            } else if (routeState is BussinessState) {
              return BlocBuilder<FirstStageBloc, FirstStageState>(
                builder: (context, state) {
                  if (state is FirstStageOpenState ||
                      state is SelectedCategoryState ||
                      state is FirstStageLoadingState) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Atliekos kodo ',
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleStyle
                                  : TextStyles.smallNavTitleStyle,
                            ),
                            TextSpan(
                              text: 'parinkimas',
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleSecondStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleSecondStyle
                                  : TextStyles.smallNavTitleSecondStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is FoundCodeState ||
                      state is CodeFoundAfterThirdStageState) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Rūšiavimo ir tvarkymo ',
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleStyle
                                  : TextStyles.smallNavTitleStyle,
                            ),
                            TextSpan(
                              text: 'rekomendacijos',
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleSecondStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleSecondStyle
                                  : TextStyles.smallNavTitleSecondStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is SecondStageLoadingState ||
                      state is SecondStageOpenState) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Specifinių kategorijų atliekų ',
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleStyle
                                  : TextStyles.smallNavTitleStyle,
                            ),
                            TextSpan(
                              text: 'identifikavimas',
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleSecondStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleSecondStyle
                                  : TextStyles.smallNavTitleSecondStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is ThirdStageOpenState ||
                      state is ThirdStageLoadingState) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Atliekų pavojingumo ',
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleStyle
                                  : TextStyles.smallNavTitleStyle,
                            ),
                            TextSpan(
                              text: 'įvertinimas',
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleSecondStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleSecondStyle
                                  : TextStyles.smallNavTitleSecondStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: LocaleKeys.nav_bussiness_page_desc.tr(),
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleStyle
                                  : TextStyles.smallNavTitleStyle,
                            ),
                            TextSpan(
                              text: LocaleKeys.nav_bussiness_page_desc2.tr(),
                              style: _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.smallNavTitleSecondStyle
                                  : _state.status == AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.smallNavTitleSecondStyle
                                  : TextStyles.smallNavTitleSecondStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            } else {
              return const SizedBox();
            }
          }
        },
      ),
    );
  }
}
