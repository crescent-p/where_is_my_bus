import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/secrets/secrets.dart';
import 'package:where_is_my_bus/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:where_is_my_bus/features/auth/data/repository/auth_repository.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_current_user_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_in_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_out_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/register_with_fastapi_usecase.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/locations/bloc/bloc/web_socket_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // Handle background message here
}

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.getInt(POSTCOUNT) == null) {
    sharedPreferences.setInt(POSTCOUNT, TOTAL_POST_COUNT);
  }
  for (int i = 0; i < SECTION_MAP.length; i++) {
    if (sharedPreferences.getInt(SECTIONS[i]) == null) {
      sharedPreferences.setInt(SECTIONS[i], TOTAL_POST_COUNT);
    }
  }
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton<GoogleSignIn>(
      () => GoogleSignIn(clientId: webClientId, scopes: [
            "email",
            "profile",
            "openid",
          ]));

  // var permission = await Geolocator.checkPermission();
  // if (permission == LocationPermission.denied) {
  //   permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     var _locationMessage = "Location permission denied.";
  //   }
  // }

  initAuth();
  initNofitications();
  initWebSocket();
}

Future<void> initWebSocket() async {
  serviceLocator.registerLazySingleton<WebSocketBloc>(() => WebSocketBloc());

}

Future<void> initNofitications() async {
  await Firebase.initializeApp();
  if (await FirebaseMessaging.instance.getToken() != null) {
    print(await FirebaseMessaging.instance.getToken());
  }
  // Foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received while app is in foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Notification title: ${message.notification!.title}');
      print('Notification body: ${message.notification!.body}');
      // Display notification to user here
    }
  });

  // Background notifications
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


}


void initAuth() {
  //Repository registrations
  serviceLocator
      .registerFactory<AuthRemoteDataSouce>(() => AuthRemoteDatasourceImpl(
            prefs: serviceLocator(),
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
  serviceLocator.registerLazySingleton<RegisterWithFastAPIUsecase>(
      () => RegisterWithFastAPIUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<UserCubit>(() => UserCubit());
  serviceLocator.registerLazySingleton<AuthBloc>(() => AuthBloc(
      registerWithFastAPIUsecase: serviceLocator(),
      authSignUpWithGoogleUsecas: serviceLocator(),
      authSignOutUseCase: serviceLocator(),
      authCurrentUserUsecase: serviceLocator(),
      userCubit: serviceLocator()));
}
