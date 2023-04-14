import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../constants/app_colors.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class HowToUseTool extends StatefulWidget {
  final HowToUseBloc howToUseBloc;

  const HowToUseTool({
    Key? key,
    required this.howToUseBloc,
  }) : super(key: key);

  @override
  State<HowToUseTool> createState() => _HowToUseToolState();
}

class _HowToUseToolState extends State<HowToUseTool> {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          child: ElevatedButton(
            onPressed: () {
              widget.howToUseBloc.add(OpenHowToUseEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyle.appBarWebColor,
              elevation: 0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.help,
                  color: AppStyle.helpIconColor,
                  size: 48,
                ),
                const SizedBox(height: 10),
                Text(
                  'Kaip naudotis įrankiu?',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.routeTracker
                          .copyWith(color: AppStyle.black.withOpacity(0.55))
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.routeTracker.copyWith(
                              color: AppStyle.black.withOpacity(0.55))
                          : TextStyles.routeTracker.copyWith(
                              color: AppStyle.black.withOpacity(0.55)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
