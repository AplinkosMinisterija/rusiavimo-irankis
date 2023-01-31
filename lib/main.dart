import 'dart:ui';

import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/routes.dart';
import 'package:aplinkos_ministerija/di/app_injector.dart';
import 'package:aplinkos_ministerija/ui/screens/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  startApp();
}

Future startApp() async {
  await EasyLocalization.ensureInitialized();

  AppInjector.setupInjector();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('lt'),
        Locale('en'),
      ],
      path: 'assets/lang',
      useOnlyLangCode: true,
      fallbackLocale: const Locale('lt'),
      startLocale: const Locale('lt'),
      child: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  final _navKey = GlobalKey<NavigatorState>();
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GetIt _getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget._navKey,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      title: 'test',
      theme: ThemeData.light().copyWith(
        canvasColor: AppColors.scaffoldColor,
      ),
      initialRoute: RouteName.main_route,
      routes: {
        RouteName.main_route: (context) => const MainScreen(),
      },
    );
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}
