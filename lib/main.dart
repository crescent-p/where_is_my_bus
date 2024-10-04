import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/loginPage.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/bus_list_page.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(MaterialApp(home: Loginpage()));
  await initDependencies();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<UserCubit>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<LocationsBloc>(),
    ),
  ], child: MaterialApp(home: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCurrentUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserCubit, UserState, UserState>(
        selector: (state) => state,
        builder: (context, state) {
          if (state is UserLoggedIn) {
            return BusListPage(user: state.getUser);
          } else {
            return Loginpage();
          }
        });
  }
}
