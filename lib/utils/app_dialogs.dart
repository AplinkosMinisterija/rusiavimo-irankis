import 'package:flutter/material.dart';

class AppDialogs {
  const AppDialogs._();

  static Future showAnimatedDialog(BuildContext context,
          {required Widget content}) =>
      showGeneralDialog(
        barrierLabel: '',
        barrierDismissible: true,
        context: context,
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, anim1, anim2) => AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          content: content,
        ),
        transitionBuilder: (context, appearAnimation, _, child) =>
            SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(appearAnimation),
          child: child,
        ),
      );
}
