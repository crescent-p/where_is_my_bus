import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:where_is_my_bus/core/secrets/secrets.dart';
import 'package:where_is_my_bus/features/auth/data/repository/auth_repository.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_current_user_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_in_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_out_usecase.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  initAuth();

  final supabase = await Supabase.initialize(
      url: supabaseDatabaseUrl, anonKey: supabaseAnon);

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void initAuth() {
  //Repository registrations
  serviceLocator.registerFactory<AuthRepository>(() => AuthRepositoryImpl());
  serviceLocator.registerFactory(
      () => AuthCurrentUserUsecase(authRepository: serviceLocator()));
  serviceLocator.registerFactory(
      () => AuthSignUpWithGoogleUsecase(repository: serviceLocator()));
  serviceLocator
      .registerFactory(() => AuthSignOutUsecase(repository: serviceLocator()));

  //BLoc Registrations
  serviceLocator.registerLazySingleton(() => AuthBloc(
      authSignUpWithGoogleUsecas: serviceLocator(),
      authSignOutUseCase: serviceLocator(),
      authCurrentUserUsecase: serviceLocator()));
}
