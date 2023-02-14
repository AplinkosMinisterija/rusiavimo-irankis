import 'package:aplinkos_ministerija/data/api/data.dart';
import 'package:aplinkos_ministerija/data/network/dio_client.dart';
import 'package:aplinkos_ministerija/data/repository.dart';
import 'package:get_it/get_it.dart';

class AppInjector {
  static GetIt getIt = GetIt.instance;

  static void setupInjector() {
    _setupDio();
    _setupApis();
    _setupRepo();
  }

  static void _setupDio() {
    getIt.registerSingleton(DioClient());
  }

  static void _setupApis() {
    getIt.registerSingleton(DataApi());
  }

  static void _setupRepo() {
    getIt.registerSingleton<Repository>(Repository(
      getIt<DataApi>(),
    ));
  }
}
