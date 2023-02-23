import 'dart:async';

import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../styles/text_styles.dart';
import 'button.dart';

class NotFoundWidget extends StatefulWidget {
  final FirstStageBloc firstStageBloc;
  OverlayEntry? overlayEntry;
  final String trashTitle;
  NotFoundWidget({
    Key? key,
    required this.firstStageBloc,
    this.overlayEntry,
    required this.trashTitle,
  }) : super(key: key);

  @override
  State<NotFoundWidget> createState() => _NotFoundWidgetState();
}

class _NotFoundWidgetState extends State<NotFoundWidget> {
  Timer? timer;
  Duration timerDuration = const Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColors.overlayColor,
          ),
          Center(
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(7)
              ),
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 600,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jūsų identifikuojamai atliekai negali būti priskirtas konkretus atliekų kodas, todėl rekomenduojama atlikti atliekų pavojingumo vertinimą',
                      style: TextStyles.selectorDescriptionTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Lorem ipsum dolor sit amet consectetur. In velit aliquam neque diam eget massa malesuada lorem. Duis cursus arcu adipiscing pharetra fringilla.',
                      style: TextStyles.searchDescStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      timerDuration.inSeconds.remainder(60) <= 9
                          ? '00:0${timerDuration.inSeconds.remainder(60)}'
                          : '00:${timerDuration.inSeconds.remainder(60)}',
                      style: TextStyles.searchDescStyle
                          .copyWith(color: AppColors.overlayColor),
                      textAlign: TextAlign.center,
                    ),
                    DefaultAccentButton(
                      title: 'Atlikti atliekų pavojingumo vertinimą',
                      textStyle: TextStyles.timerTextStyle,
                      textAlign: TextAlign.center,
                      onPressed: () {
                        timer!.cancel();
                        removeOverlay();
                        widget.firstStageBloc.add(OpenThirdStageEvent(trashTitle: widget.trashTitle));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      widget.firstStageBloc.add(OpenThirdStageEvent(trashTitle: widget.trashTitle));
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
