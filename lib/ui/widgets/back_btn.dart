import 'dart:html';

import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../constants/app_colors.dart';
import '../styles/text_styles.dart';

class BackButtonWidget extends StatefulWidget {
  final FirstStageBloc firstStageBloc;
  final RouteControllerBloc routeControllerBloc;

  const BackButtonWidget({
    Key? key,
    required this.firstStageBloc,
    required this.routeControllerBloc,
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
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenBtnHoover,
                shape: const CircleBorder(),
              ),
              onPressed: () {
                if (state is FirstStageOpenState) {
                  widget.firstStageBloc.add(BackToInitialEvent());
                } else if (state is SelectedCategoryState) {
                  widget.firstStageBloc.add(OpenFirstStageEvent());
                } else if (state is SecondStageOpenState) {
                  widget.firstStageBloc.add(OpenFirstStageEvent());
                } else if (state is ThirdStageOpenState) {
                  widget.firstStageBloc.add(OpenFirstStageEvent());
                } else if (routeState is BussinessState &&
                    state is FirstStageInitial) {
                  widget.routeControllerBloc.add(OpenHomeScreenEvent());
                } else if (routeState is ResidentsState &&
                    state is FirstStageInitial) {
                  widget.routeControllerBloc.add(OpenHomeScreenEvent());
                } else if (state is FoundCodeState ||
                    state is CodeFoundAfterThirdStageState) {
                  widget.firstStageBloc.add(BackToInitialEvent());
                } else if (state is StartFromSecondStageSelectedCategoryState) {
                  widget.firstStageBloc.add(StartFromSecondStageEvent());
                } else if (state is StartForSecondStageState) {
                  widget.firstStageBloc.add(BackToInitialEvent());
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal:
                        MediaQuery.of(context).size.width > 768 ? 20 : 0),
                child: const Icon(Icons.arrow_back),
              ),
            );
          },
        );
      },
    );
  }
}
