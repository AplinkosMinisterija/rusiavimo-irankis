import 'dart:ui';

import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/routes.dart';
import 'package:aplinkos_ministerija/data/repository.dart';
import 'package:aplinkos_ministerija/di/app_injector.dart';
import 'package:aplinkos_ministerija/ui/screens/bussiness.dart';
import 'package:aplinkos_ministerija/ui/screens/main_screen.dart';
import 'package:aplinkos_ministerija/ui/screens/residents.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'bloc/nav_bar_bloc/nav_bar_bloc.dart';
import 'bloc/stages_cotroller/first_stage_bloc.dart';

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
    final shortcuts = Map.of(WidgetsApp.defaultShortcuts)
      ..remove(LogicalKeySet(LogicalKeyboardKey.escape));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavBarBloc()),
        BlocProvider(create: (_) => HowToUseBloc()),
        BlocProvider(create: (_) => RouteControllerBloc()),
        BlocProvider(
          create: (_) => FirstStageBloc(
            repo: _getIt.get<Repository>(),
          ),
        ),
      ],
      child: MaterialApp(
        // navigatorKey: widget._navKey,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        shortcuts: shortcuts,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        title: 'Aplinkos Ministerija',
        theme: ThemeData.light().copyWith(
          canvasColor: AppColors.scaffoldColor,
        ),
        home: const MainScreen(),
        // initialRoute: RouteName.main_route,
        // routes: {
        //   RouteName.main_route: (context) => const MainScreen(),
        //   RouteName.residents_route: (context) => const ResidentsScreen(),
        //   RouteName.bussiness_route: (context) => const BussinessScreen(),
        // },
      ),
    );
  }
}
