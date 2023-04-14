import 'dart:async';

import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../constants/app_colors.dart';
import '../../model/category.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import 'button.dart';

class NotFoundWidget extends StatefulWidget {
  final FirstStageBloc firstStageBloc;
  OverlayEntry? overlayEntry;
  final String trashTitle;
  final String trashCode;
  final String trashType;
  final List<Category> listOfCategories;

  NotFoundWidget({
    Key? key,
    required this.firstStageBloc,
    this.overlayEntry,
    required this.trashTitle,
    required this.listOfCategories,
    required this.trashType,
    required this.trashCode,
  }) : super(key: key);

  @override
  State<NotFoundWidget> createState() => _NotFoundWidgetState();
}

class _NotFoundWidgetState extends State<NotFoundWidget> {
  Timer? timer;
  Duration timerDuration = const Duration(seconds: 30);
  late AccessibilityControllerState _state;

  @override
  void initState() {
    super.initState();
    startTimer();
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppStyle.overlayColor,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: (MediaQuery.of(context).size.width > 768)
                  ? MediaQuery.of(context).size.width * 0.15
                  : MediaQuery.of(context).size.width * 0.14,
              horizontal: (MediaQuery.of(context).size.width > 768)
                  ? MediaQuery.of(context).size.width * 0.3
                  : MediaQuery.of(context).size.width * 0.1,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: AppStyle.scaffoldColor,
                  borderRadius: BorderRadius.circular(7)),
              padding: const EdgeInsets.all(20),
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jūsų identifikuojamai atliekai negali būti priskirtas konkretus atliekų kodas, todėl rekomenduojama atlikti atliekų pavojingųjų savybių vertinimą',
                        style: (MediaQuery.of(context).size.width > 768)
                            ? _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.selectorDescriptionTitleStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest
                                        .selectorDescriptionTitleStyle
                                    : TextStyles.selectorDescriptionTitleStyle
                            : _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger
                                    .mobileSelectorDescriptionTitleStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest
                                        .mobileSelectorDescriptionTitleStyle
                                    : TextStyles
                                        .mobileSelectorDescriptionTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        timerDuration.inSeconds.remainder(60) <= 9
                            ? '00:0${timerDuration.inSeconds.remainder(60)}'
                            : '00:${timerDuration.inSeconds.remainder(60)}',
                        style: _state.status ==
                                AccessibilityControllerStatus.big
                            ? TextStylesBigger.searchDescStyle
                                .copyWith(color: AppStyle.overlayColor)
                            : _state.status ==
                                    AccessibilityControllerStatus.biggest
                                ? TextStylesBiggest.searchDescStyle
                                    .copyWith(color: AppStyle.overlayColor)
                                : TextStyles.searchDescStyle
                                    .copyWith(color: AppStyle.overlayColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      DefaultAccentButton(
                        title: 'Atlikti vertinimą',
                        paddingFromTop: 5,
                        textStyle: (MediaQuery.of(context).size.width > 768)
                            ? _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.timerTextStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.timerTextStyle
                                    : TextStyles.timerTextStyle
                            : _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.mobileTimerTextStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.mobileTimerTextStyle
                                    : TextStyles.mobileTimerTextStyle,
                        textAlign: TextAlign.center,
                        onPressed: () {
                          timer!.cancel();
                          removeOverlay();
                          widget.firstStageBloc.add(OpenThirdStageEvent(
                            trashTitle: widget.trashTitle,
                            trashCode: widget.trashCode,
                            trashType: widget.trashType,
                            listOfCategories: widget.listOfCategories,
                          ));
                        },
                      ),
                      const SizedBox(height: 10),
                      DefaultAccentButton(
                        title: 'Grįžti į pradžią',
                        paddingFromTop: 5,
                        textStyle: (MediaQuery.of(context).size.width > 768)
                            ? _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.timerTextStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.timerTextStyle
                                    : TextStyles.timerTextStyle
                            : _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.mobileTimerTextStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.mobileTimerTextStyle
                                    : TextStyles.mobileTimerTextStyle,
                        textAlign: TextAlign.center,
                        onPressed: () {
                          timer!.cancel();
                          removeOverlay();
                          widget.firstStageBloc.add(OpenFirstStageEvent());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final seconds = timerDuration.inSeconds - 1;
    if (seconds < 0) {
      timer!.cancel();
      removeOverlay();
      widget.firstStageBloc.add(OpenThirdStageEvent(
        trashTitle: widget.trashTitle,
        trashCode: widget.trashCode,
        trashType: widget.trashType,
        listOfCategories: widget.listOfCategories,
      ));
    } else {
      timerDuration = Duration(seconds: seconds);
    }
    setState(() {});
  }

  void removeOverlay() {
    widget.overlayEntry!.remove();
    widget.overlayEntry = null;
  }
}
