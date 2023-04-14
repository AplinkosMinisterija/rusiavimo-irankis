import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';

class WrongPath extends StatefulWidget {
  const WrongPath({Key? key}) : super(key: key);

  @override
  State<WrongPath> createState() => _WrongPathState();
}

class _WrongPathState extends State<WrongPath> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, "/");
      },
    );
    return const Scaffold(
      body: Center(
        child: Text(
          'Blogas url, puslapis persijungs už 3 sec.',
          style: TextStyles.itemTitleStyle,
        ),
      ),
    );
  }
}
