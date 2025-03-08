import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/core/common/widgets/loading_screen.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/locations/bloc/bloc/web_socket_bloc.dart';
import 'package:where_is_my_bus/features/locations/pages/map_view.dart';
import 'package:where_is_my_bus/init_dependencies.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // Register MethodChannel
  // const MethodChannel platformChannel = MethodChannel('com.example.channel');

  // Listen for calls from the background service
  // platformChannel.setMethodCallHandler((MethodCall call) async {
  //   switch (call.method) {
  //     case 'updateUI':
  //       // Perform specific actions in the main isolate
  //       final arguments = call.arguments;
  //       print("Received updateUI with arguments: $arguments");
  //       break;
  //     default:
  //       throw PlatformException(
  //         code: 'Unimplemented',
  //         details: "The method ${call.method} is not implemented.",
  //       );
  //   }
  // });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Locks portrait mode
  ]).then((_) {
    runApp(MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => serviceLocator<UserCubit>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<AuthBloc>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<WebSocketBloc>(),
          ),
        ],
        child: const MaterialApp(
          home: MyApp(),
          debugShowCheckedModeBanner: false,
        )));
  });
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
    // initBackground();
    context.read<AuthBloc>().add(AuthCurrentUserEvent());
  }

  // Future<void> initBackground() async {
  //   final service = FlutterBackgroundService();

  //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     notificationChannelId,
  //     'Background services for where is my bus.',
  //     description: 'This notification is used for finding buses near you.',
  //     importance: Importance.low,
  //   );

  //   // Create notification channel for Android
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);

  //   await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       onStart: onStart,
  //       autoStart: true,
  //       isForegroundMode: true,
  //       notificationChannelId: notificationChannelId,
  //       initialNotificationTitle: 'Background Service for Where is my Bus?',
  //       initialNotificationContent: 'Searching for Buses near you!',
  //       foregroundServiceNotificationId: NOTIFICATION_ID,
  //     ),
  //     iosConfiguration: IosConfiguration(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MapScreen()),
          );
        } else if (state is UserLoggedOut) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Loginpage()),
          );
        }
      },
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            return const LoadingScreen();
          } else {
            return const SizedBox
                .shrink(); // Return an empty widget as the actual navigation is handled in the listener
          }
        },
      ),
    );
  }
}

// void onStart(ServiceInstance service) {
//   // Handle background service logic
//   service.on('data').listen((data) {
//     if (data != null) {
//       final message = data['message'] ?? 'No Message';
//       print("Background Service Received: $message");

//       // Send data to the main isolate
//       const MethodChannel platformChannel =
//           MethodChannel('com.example.channel');
//       platformChannel.invokeMethod('updateUI', {'message': message});
//     }
//   });
// }
