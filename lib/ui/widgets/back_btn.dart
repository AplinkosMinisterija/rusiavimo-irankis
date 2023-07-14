import 'dart:html';

import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../constants/app_colors.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';

class BackButtonWidget extends StatefulWidget {
  final FirstStageBloc firstStageBloc;
  final RouteControllerBloc routeControllerBloc;
  final Function()? customBackFunction;

  const BackButtonWidget({
    Key? key,
    required this.firstStageBloc,
    required this.routeControllerBloc,
    this.customBackFunction,
  }) : super(key: key);

  @override
  State<BackButtonWidget> createState() => _BackButtonWidgetState();
}

class _BackButtonWidgetState extends State<BackButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
      builder: (context, routeState) {
        return BlocBuilder<FirstStageBloc, FirstStageState>(
          builder: (context, state) {
            return TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.greenBtnHoover,
                shape: const CircleBorder(),
              ),
              onPressed: widget.customBackFunction ??
                  () {
                    if (state is FirstStageOpenState) {
                      widget.firstStageBloc.add(StartFromSecondStageEvent());
                    } else if (state is SelectedCategoryState) {
                      widget.firstStageBloc.add(OpenFirstStageEvent());
                    } else if (state is SecondStageOpenState) {
                      if (state.fromEntryPoint != null &&
                          state.fromEntryPoint == true) {
                        widget.firstStageBloc.add(StartFromSecondStageEvent());
                      } else {
                        widget.firstStageBloc.add(OpenFirstStageEvent());
                      }
                    } else if (state is ThirdStageOpenState) {
                      if (state.fromEntryPoint != null &&
                          state.fromEntryPoint == true) {
                        widget.firstStageBloc.add(StartFromSecondStageEvent());
                      } else {
                        widget.firstStageBloc.add(OpenFirstStageEvent());
                      }
                    } else if (routeState is BussinessState &&
                        state is StartForSecondStageState) {
                      widget.routeControllerBloc.add(OpenHomeScreenEvent());
                    } else if (routeState is ResidentsState) {
                      widget.routeControllerBloc.add(OpenHomeScreenEvent());
                    } else if (state
                        is StartFromSecondStageSelectedCategoryState) {
                      widget.firstStageBloc.add(StartFromSecondStageEvent());
                    } else if (state is FoundCodeState) {
                      if (state.fromEntryPoint != null &&
                          state.fromEntryPoint == true) {
                        widget.firstStageBloc.add(StartFromSecondStageEvent());
                      } else {
                        widget.firstStageBloc.add(OpenFirstStageEvent());
                      }
                    } else if (state is CodeFoundAfterThirdStageState) {
                      widget.firstStageBloc.add(
                        OpenThirdStageEvent(
                          trashTitle: state.trashTitle,
                          listOfCategories: [],
                          trashType: state.trashType,
                          trashCode: '',
                          fromEntryPoint: state.fromEntryPoint,
                        ),
                      );
                    }
                  },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal:
                        MediaQuery.of(context).size.width > 768 ? 20 : 0),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
