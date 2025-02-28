import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:where_is_my_bus/features/main_page/data/data_sources/locations_remote_datasource.dart';
import 'package:where_is_my_bus/features/main_page/data/repository_impl/locations_repository_impl.dart';
import 'package:where_is_my_bus/features/main_page/domain/repository/locations_repository.dart';
import 'package:where_is_my_bus/features/main_page/domain/usecases/get_bus_locations_usecase.dart';
import 'package:where_is_my_bus/features/main_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/main_page/presentation/cubit/bottom_nav_cubit.dart';
import 'package:where_is_my_bus/features/social/data/data_source/social_local_datasource.dart';
import 'package:where_is_my_bus/features/social/data/data_source/social_remote_datasource.dart';
import 'package:where_is_my_bus/features/social/data/database/hive_object.dart';
import 'package:where_is_my_bus/features/social/data/database/hive_storage.dart';
import 'package:where_is_my_bus/features/social/data/repository_impl/social_repository_impl.dart';
import 'package:where_is_my_bus/features/social/domain/repository/social_repository.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/add_comment_usecase.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_mini_posts_usecase.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_specific_post_usecase.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/comments_bloc/comments_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/mini_posts_bloc/mini_posts_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/social_bloc/social_bloc.dart';

import 'features/social/domain/usecases/get_comments_usecase.dart';

final serviceLocator = GetIt.instance;

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
  initLocations();
  initSocial();
  initComments();
  initMiniPosts();
  await initDatabase();
}

void initMiniPosts() {
  serviceLocator.registerLazySingleton<MiniPostsBloc>(
      () => MiniPostsBloc(getMiniPostsUsecase: serviceLocator()));
}

Future<void> initComments() async {
  serviceLocator.registerLazySingleton<CommentsBloc>(() => CommentsBloc(
      getCommentsUsecase: serviceLocator(),
      addCommentUsecase: serviceLocator()));
  serviceLocator.registerLazySingleton<AddCommentUsecase>(
      () => AddCommentUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetCommentsUsecase>(
      () => GetCommentsUsecase(repository: serviceLocator()));
}

Future<void> initDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  print('Hive Path: ${dir.path}');
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path); // Provide the path to Hive boxes
  Hive.registerAdapter(HivePostAdapter()); // Register the TypeAdapter
  Hive.registerAdapter(HiveMiniPostAdapter());
  await Hive.openBox<HivePost>('posts'); // Open a Hive box
  await Hive.openBox<HiveMiniPost>('minipost');
  final HiveStorage storage =
      HiveStorageImpl(hive: Hive, preferences: serviceLocator());
  serviceLocator.registerLazySingleton<HiveStorage>(() => storage);
}

void initSocial() {
  serviceLocator.registerLazySingleton<Connectivity>(
    () => Connectivity(),
  );
  serviceLocator.registerLazySingleton<SocialRemoteDataSource>(
      () => SocialRemoteDataSourceImple());
  serviceLocator
      .registerLazySingleton<SocialRepository>(() => SocialRepositoryImpl(
            socialLocalDataSource: serviceLocator(),
            socialRemoteDataSource: serviceLocator(),
            connectivity: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<GetMiniPostsUsecase>(
      () => GetMiniPostsUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<SocialLocalDataSource>(
      () => SocialLocalDataSourceImple(storage: serviceLocator()));
  serviceLocator.registerLazySingleton<SocialBloc>(() => SocialBloc(
        getSpecificPostUseCase: serviceLocator(),
        getCommentsUsecase: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton<GetSpecificPostUseCase>(
      () => GetSpecificPostUseCase(repository: serviceLocator()));
}

void initLocations() {
  serviceLocator.registerFactory<LocationsRemoteDatasource>(
      () => LocationsRemoteDatasourceImpl(
            prefs: serviceLocator(),
          ));
  serviceLocator
      .registerFactory<LocationsRepository>(() => LocationsRepositoryImpl(
            repository: serviceLocator(),
          ));
  serviceLocator
      .registerFactory<GetBusLocationsUsecase>(() => GetBusLocationsUsecase(
            repository: serviceLocator(),
          ));
  // serviceLocator.registerFactory<UpdateCurrentLocationUsecase>(
  //     () => UpdateCurrentLocationUsecase(
  //           repository: serviceLocator(),
  //         ));
  serviceLocator.registerLazySingleton<LocationsBloc>(() => LocationsBloc(
        getBusLocationsUsecase: serviceLocator(),
        // updateCurrentLocationUsecase: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton<BottomNavCubit>(() => BottomNavCubit());
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
