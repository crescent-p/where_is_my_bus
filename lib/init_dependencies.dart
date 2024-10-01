import 'package:flutter_background/flutter_background.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/core/secrets/secrets.dart';
import 'package:where_is_my_bus/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:where_is_my_bus/features/auth/data/repository/auth_repository.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_current_user_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_in_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_out_usecase.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/data/data_sources/locations_remote_datasource.dart';
import 'package:where_is_my_bus/features/bus_list_page/data/repository_impl/locations_repository_impl.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/repository/locations_repository.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/usecases/get_bus_locations_usecase.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/usecases/update_current_location_usecase.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
      url: supabaseDatabaseUrl, anonKey: supabaseAnon);
  serviceLocator.registerLazySingleton<GoogleSignIn>(
      () => GoogleSignIn(clientId: webClientId, scopes: [
            "email",
            "profile",
            "openid",
          ]));
  serviceLocator.registerLazySingleton(() => supabase.client);
  initAuth();
  initLocations();
  initBackground();
}

Future<void> initBackground() async {
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Background Service",
    notificationText: "Your app is running in the background",
    enableWifiLock: true, // Keep Wi-Fi active during background execution
  );

  bool success = await FlutterBackground.initialize(androidConfig: androidConfig);

  if (success) {
    FlutterBackground.enableBackgroundExecution();
  }
}

void initLocations() {
  serviceLocator.registerFactory<LocationsRemoteDatasource>(
      () => LocationsRemoteDatasourceImpl(
            client: serviceLocator(),
          ));
  serviceLocator
      .registerFactory<LocationsRepository>(() => LocationsRepositoryImpl(
            repository: serviceLocator(),
          ));
  serviceLocator
      .registerFactory<GetBusLocationsUsecase>(() => GetBusLocationsUsecase(
            repository: serviceLocator(),
          ));
  serviceLocator.registerFactory<UpdateCurrentLocationUsecase>(
      () => UpdateCurrentLocationUsecase(
            repository: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<LocationsBloc>(() => LocationsBloc(
        getBusLocationsUsecase: serviceLocator(),
        updateCurrentLocationUsecase: serviceLocator(),
      ));
}

void initAuth() {
  //Repository registrations
  serviceLocator
      .registerFactory<AuthRemoteDataSouce>(() => AuthRemoteDatasourceImpl(
            client: serviceLocator(),
            googleSignIn: serviceLocator(),
          ));

  serviceLocator.registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        authRemoteDataSouce: serviceLocator(),
      ));
  serviceLocator.registerFactory<AuthCurrentUserUsecase>(
      () => AuthCurrentUserUsecase(authRepository: serviceLocator()));
  serviceLocator.registerFactory<AuthSignUpWithGoogleUsecase>(
      () => AuthSignUpWithGoogleUsecase(repository: serviceLocator()));
  serviceLocator
      .registerFactory(() => AuthSignOutUsecase(repository: serviceLocator()));

  //BLoc Registrations
  serviceLocator.registerLazySingleton<UserCubit>(() => UserCubit());
  serviceLocator.registerLazySingleton<AuthBloc>(() => AuthBloc(
      authSignUpWithGoogleUsecas: serviceLocator(),
      authSignOutUseCase: serviceLocator(),
      authCurrentUserUsecase: serviceLocator(),
      userCubit: serviceLocator()));
}
