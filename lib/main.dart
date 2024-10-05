import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/core/common/widgets/loading_screen.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/loginPage.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/bus_list_page.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<UserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<LocationsBloc>(),
        ),
      ],
      child: const MaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false,
      )));
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
    return BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            return LoadingScreen();
          } else if (state is UserLoggedIn) {
            return BusListPage(user: state.getUser);
          } else if (state is UserLoggedOut) {
            return const Loginpage();
          } else {
            // TODO: change to LoginPage in production.
            return Text("Some Unknown Error\n");
          }
        });
  }
}
