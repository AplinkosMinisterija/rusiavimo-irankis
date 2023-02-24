import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';

import '../../bloc/route_controller/route_controller_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../generated/locale_keys.g.dart';
import '../styles/text_styles.dart';

class MobileSmallNavBar extends StatefulWidget {
  final RouteControllerBloc routeControllerBloc;

  const MobileSmallNavBar({
    Key? key,
    required this.routeControllerBloc,
  }) : super(key: key);

  @override
  State<MobileSmallNavBar> createState() => _MobileSmallNavBarState();
}

class _MobileSmallNavBarState extends State<MobileSmallNavBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
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
                    },
                  ),
                  _buildSmallNavBtn(
                    title: LocaleKeys.economic_entities.tr().toCapitalized(),
                    isMarked: state is BussinessState ? true : false,
                    onClick: () {
                      widget.routeControllerBloc
                          .add(OpenBussinessScreenEvent());
                    },
                  ),
                ],
              ),
            ),
            _buildTitle(),
          ],
        );
      },
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
          color: isMarked ? AppColors.scaffoldColor : AppColors.appBarWebColor,
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
                    ? TextStyles.smallNavBarStyle
                    : TextStyles.smallNavBarStyle
                        .copyWith(color: AppColors.black.withOpacity(0.1)),
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
          if (routeState is RouteControllerInitial) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: LocaleKeys.nav_description_first.tr(),
                      style: TextStyles.smallNavTitleStyle,
                    ),
                    TextSpan(
                      text: LocaleKeys.nav_description_second.tr(),
                      style: TextStyles.smallNavTitleSecondStyle,
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
                      style: TextStyles.smallNavTitleStyle,
                    ),
                    TextSpan(
                      text: LocaleKeys.nav_second_page_desc2.tr(),
                      style: TextStyles.smallNavTitleSecondStyle,
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
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Atliekos kodo ',
                            style: TextStyles.smallNavTitleStyle,
                          ),
                          TextSpan(
                            text: 'parinkimas',
                            style: TextStyles.smallNavTitleSecondStyle,
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
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rūšiavimo ir tvarkymo ',
                            style: TextStyles.smallNavTitleStyle,
                          ),
                          TextSpan(
                            text: 'rekomendacijos',
                            style: TextStyles.smallNavTitleSecondStyle,
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
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Specifinių kategorijų atliekų ',
                            style: TextStyles.smallNavTitleStyle,
                          ),
                          TextSpan(
                            text: 'identifikavimas',
                            style: TextStyles.smallNavTitleSecondStyle,
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
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Atliekų pavojingumo ',
                            style: TextStyles.smallNavTitleStyle,
                          ),
                          TextSpan(
                            text: 'įvertinimas',
                            style: TextStyles.smallNavTitleSecondStyle,
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
                            style: TextStyles.smallNavTitleStyle,
                          ),
                          TextSpan(
                            text: LocaleKeys.nav_bussiness_page_desc2.tr(),
                            style: TextStyles.smallNavTitleSecondStyle,
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
        },
      ),
    );
  }
}
