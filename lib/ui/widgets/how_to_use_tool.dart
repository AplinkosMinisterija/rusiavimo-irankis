import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../styles/text_styles.dart';

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        child: ElevatedButton(
          onPressed: () {
            widget.howToUseBloc.add(OpenHowToUseEvent());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appBarWebColor,
            elevation: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ),
    );
  }
}
