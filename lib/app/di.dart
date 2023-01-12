import 'package:complete_advanced_flutter/app/logger_settings.dart';
import 'package:complete_advanced_flutter/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:complete_advanced_flutter/data/network/app_api.dart';
import 'package:complete_advanced_flutter/data/network/dio_factory.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/data/repository/repository_impl.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:complete_advanced_flutter/domain/usecase/create_art_usecase.dart';
import 'package:complete_advanced_flutter/domain/usecase/inituser_usecase.dart';
import 'package:complete_advanced_flutter/presentation/resultpage/result_page_view_model.dart';
import 'package:complete_advanced_flutter/presentation/settings/settings_viewmodel.dart';
import 'package:complete_advanced_flutter/presentation/splash/splash_view_model.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import '../presentation/main/main_view_model.dart';
import '../presentation/premium/premium_viewmodel.dart';
import 'app_prefs.dart';
import 'helpers/revenue_cat.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  //Fireba se initalization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // shared prefs instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  // network info
  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  // app  service client
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImplementer(instance()));

  // local data source
  instance.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImplementer());

  // repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));

  instance.registerLazySingleton<RevenueCatHelper>(() => RevenueCatHelper());
}

initResultModule() {
  if (!GetIt.I.isRegistered<ResultViewModel>()) {
    instance.registerFactory<ResultViewModel>(() => ResultViewModel());
  }
}

initSplashModule() {
  if (!GetIt.I.isRegistered<InitUserUseCase>()) {
    instance
        .registerFactory<InitUserUseCase>(() => InitUserUseCase(instance()));
    instance
        .registerFactory<SplashViewModel>(() => SplashViewModel(instance()));

    // instance.registerFactory<RevenueCatHelper>(() => RevenueCatHelper());
  }
}

initMainView() {
  if (!GetIt.I.isRegistered<CreateArtUseCase>()) {
    instance
        .registerFactory<CreateArtUseCase>(() => CreateArtUseCase(instance()));
    instance.registerFactory<MainViewModel>(() => MainViewModel(instance(),instance()));
  }
}

initSettingsModule() {
  if (!GetIt.I.isRegistered<SettingsViewModel>()) {
    instance.registerFactory<SettingsViewModel>(() => SettingsViewModel());
  }
}

initPremiumModule() {
  if (!GetIt.I.isRegistered<SubscriptionViewModel>()) {
    // instance.registerFactory<RevenueCatHelper>(() => RevenueCatHelper());
    instance
        .registerFactory<SubscriptionViewModel>(() => SubscriptionViewModel());
  }
}

resetModules() {
  instance.reset(dispose: false);
  initAppModule();
}
