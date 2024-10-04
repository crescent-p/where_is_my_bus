import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
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

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      var _locationMessage = "Location permission denied.";
    }
  }

  initAuth();
  initLocations();
  initBackground();
}

const notificationChannelId = 'Location Service for Where is my bus';

Future<void> initBackground() async {
  FlutterForegroundTask.initCommunicationPort();
  @pragma('vm:entry-point')
  void startCallback() {
    // The setTaskHandler function must be called to handle the task in the background.
    FlutterForegroundTask.setTaskHandler(LocationsHandler());
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'hello'),
        ],
        callback: startCallback,
      );
    }
  }

  _startService();
}

class LocationsHandler extends TaskHandler {
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("Background Task completed\n");
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    if (timestamp.second % 5 == 0) {
      FlutterForegroundTask.sendDataToMain("update_location");
    }
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("Background Process Started\n");
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
