import 'dart:ui';

import 'package:aplinkos_ministerija/bloc/accessibility_controller/accessibility_controller_cubit.dart';
import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/share/share_manager_cubit.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/routes.dart';
import 'package:aplinkos_ministerija/data/repository.dart';
import 'package:aplinkos_ministerija/di/app_injector.dart';
import 'package:aplinkos_ministerija/ui/screens/main_screen.dart';
import 'package:aplinkos_ministerija/ui/styles/app_style.dart';
import 'package:aplinkos_ministerija/ui/styles/app_theme.dart';
import 'package:aplinkos_ministerija/utils/app_state_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:provider/provider.dart';
import 'package:themed/themed.dart';

import 'bloc/nav_bar_bloc/nav_bar_bloc.dart';
import 'bloc/stages_cotroller/first_stage_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorage.webStorageDirectory,
  );
  startApp();
}

Future startApp() async {
  await EasyLocalization.ensureInitialized();
  AppInjector.setupInjector();
  MainRouter.setupRouter();
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
      child: const MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
        BlocProvider(create: (_) => ShareManagerCubit()),
        BlocProvider(create: (_) => AccessibilityControllerCubit()),
      ],
      child: BlocBuilder<AccessibilityControllerCubit,
          AccessibilityControllerState>(
        builder: (context, state) {
          return Themed(
            currentTheme: AppStyle().getCurrentTheme(
                BlocProvider.of<AccessibilityControllerCubit>(context)
                        .state
                        .blindness ==
                    AccessibilityControllerBlindness.normal),
            child: MaterialApp(
              theme: AppTheme.themeData,
              darkTheme: AppTheme.themeDataDark,
              themeMode:
                  state.blindness == AccessibilityControllerBlindness.normal
                      ? ThemeMode.light
                      : ThemeMode.dark,
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              shortcuts: shortcuts,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              title: 'Aplinkos Ministerija',
              // initialRoute: '/',
              // onGenerateRoute: MainRouter.router.generator,
              home: const MainScreen(),
            ),
          );
        },
      ),
    );
  }
}
