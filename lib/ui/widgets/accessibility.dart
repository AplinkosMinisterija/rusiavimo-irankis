import 'package:aplinkos_ministerija/bloc/accessibility_controller/accessibility_controller_cubit.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../styles/app_style.dart';

class Accessibility extends StatefulWidget {
  const Accessibility({Key? key}) : super(key: key);

  @override
  State<Accessibility> createState() => _AccessibilityState();
}

class _AccessibilityState extends State<Accessibility> {
  late bool font1;
  late bool font2;
  late bool font3;
  late bool colorBlind;
  late AccessibilityControllerCubit _accessibilityControllerCubit;

  @override
  void initState() {
    super.initState();
    _accessibilityControllerCubit =
        BlocProvider.of<AccessibilityControllerCubit>(context);
    AccessibilityControllerState state = _accessibilityControllerCubit.state;
    if (state.status == AccessibilityControllerStatus.normal) {
      font1 = true;
      font2 = false;
      font3 = false;
    } else if (state.status == AccessibilityControllerStatus.big) {
      font1 = false;
      font2 = true;
      font3 = false;
    } else if (state.status == AccessibilityControllerStatus.biggest) {
      font1 = false;
      font2 = false;
      font3 = true;
    }
    if (state.blindness == AccessibilityControllerBlindness.blind) {
      colorBlind = true;
    } else {
      colorBlind = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _closeButton(),
        const SizedBox(height: 10),
        _buildColorBlindWindow(),
        const SizedBox(height: 10),
        _buildFontSizeWindow(),
        const SizedBox(height: 10),
        _buildConfirmationButton(),
      ],
    );
  }

  Widget _buildColorBlindWindow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Išjungti spalvas'),
        IconButton(
          onPressed: () {
            colorBlind = !colorBlind;
            setState(() {});
          },
          icon: Icon(
            colorBlind
                ? Icons.check_box
                : Icons.check_box_outline_blank_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationButton() {
    return DefaultAccentButton(
      title: 'Patvirtinti',
      onPressed: () {
        if (colorBlind) {
          _accessibilityControllerCubit.enableColorBlind();
          if (font1) {
            _accessibilityControllerCubit.changeToNormalStyle();
          } else if (font2) {
            _accessibilityControllerCubit.changeToBiggerStyle();
          } else if (font3) {
            _accessibilityControllerCubit.changeToBiggestStyle();
          }
        } else {
          _accessibilityControllerCubit.disableColorBlind();
          if (font1) {
            _accessibilityControllerCubit.changeToNormalStyle();
          } else if (font2) {
            _accessibilityControllerCubit.changeToBiggerStyle();
          } else if (font3) {
            _accessibilityControllerCubit.changeToBiggestStyle();
          }
        }
        Navigator.pop(context);
      },
    );
  }

  Widget _buildFontSizeWindow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildFontSize(
          onPressed: () {
            font1 = true;
            font2 = false;
            font3 = false;
            setState(() {});
          },
          fontSelector: font1,
          fontSize: 14,
        ),
        const SizedBox(width: 10),
        _buildFontSize(
          onPressed: () {
            font1 = false;
            font2 = true;
            font3 = false;
            setState(() {});
          },
          fontSelector: font2,
          fontSize: 18,
        ),
        const SizedBox(width: 10),
        _buildFontSize(
          onPressed: () {
            font1 = false;
            font2 = false;
            font3 = true;
            setState(() {});
          },
          fontSelector: font3,
          fontSize: 22,
        ),
      ],
    );
  }

  Widget _buildFontSize({
    required Function() onPressed,
    required bool fontSelector,
    required double fontSize,
  }) {
    return Column(
      children: [
        Text(
          'A',
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            fontSelector ? Icons.check_circle_outline : Icons.circle_outlined,
          ),
        ),
      ],
    );
  }

  Widget _closeButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.accessibility,
                color: AppStyle.greenBtnUnHoover,
                size: 25,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text(
                  'Pritaikymas neįgaliesiems',
                ),
              ),
            ],
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
