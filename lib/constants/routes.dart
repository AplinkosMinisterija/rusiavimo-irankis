import 'package:aplinkos_ministerija/ui/screens/main_screen.dart';
import 'package:aplinkos_ministerija/ui/screens/recomendations.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../ui/screens/final_recomendations.dart';
import '../ui/widgets/wrong_path.dart';

class MainRouter {
  static FluroRouter router = FluroRouter();

  static final Handler _mainRoute = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
        const MainScreen(),
  );

  static final Handler _recommendHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String? title;
    String? code;
    String? type;
    try {
      title = Uri.decodeFull(params['title'][0]);
      code = Uri.decodeFull(params['code'][0]);
      type = Uri.decodeFull(params['type'][0]);
    } catch (e) {
      title = params['title'][0];
      code = params['code'][0];
      type = params['type'][0];
    }
    if(title != null && code != null && type != null) {
      return RecomendationScreen(
        title: title,
        trashCode: code,
        trashType: type,
      );
    } else {
      return const WrongPath();
    }
  });

  static final Handler _finalHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String? type;
    try {
      type = Uri.decodeFull(params['type'][0]);
    } catch (e) {
      type = params['type'][0];
    }
    String? title = type == 'AN'
        ? 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VN tipo atliekų kodu ir tvarkomos kaip nepavojingosios atliekos'
        : type == 'AP'
            ? 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VP tipo atliekų kodu ir tvarkomos kaip pavojingosios atliekos'
            : null;
    if(title != null) {
      return FinalRecomendationsScreen(
        title: title!,
        trashType: type!,
      );
    } else {
      return const WrongPath();
    }
  });

  static void setupRouter() {
    router.define(
      'recomendations/:title/:code/:type',
      handler: _recommendHandler,
      transitionDuration: const Duration(seconds: 0),
    );

    router.define(
      'final/:type',
      handler: _finalHandler,
      transitionDuration: const Duration(seconds: 0),
    );

    router.define(
      '/',
      handler: _mainRoute,
      transitionDuration: const Duration(seconds: 0),
    );

    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const WrongPath();
    });
  }
}
