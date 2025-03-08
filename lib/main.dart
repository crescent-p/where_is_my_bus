import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/core/common/widgets/loading_screen.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/locations/bloc/bloc/web_socket_bloc.dart';
import 'package:where_is_my_bus/features/locations/pages/map_view.dart';
import 'package:where_is_my_bus/features/main_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/main_page/presentation/cubit/bottom_nav_cubit.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/main_page.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/comments_bloc/comments_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/mini_posts_bloc/mini_posts_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/notification_bloc/notification_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/social_bloc/social_bloc.dart';
import 'package:where_is_my_bus/init_dependencies.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/loginPage.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void startForegroundService() async {
  ForegroundService().start();
  debugPrint("Started service");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

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
            create: (_) => serviceLocator<LocationsBloc>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<SocialBloc>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<BottomNavCubit>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<CommentsBloc>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<MiniPostsBloc>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<NotificationBloc>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<WebSocketBloc>(),
          ),
        ],
        child: MaterialApp(
          home: MyApp(),
          debugShowCheckedModeBanner: false,
        )));
  });
}

void startLocation() {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://68.233.101.85/locations/send'),
  );

  Timer.periodic(Duration(seconds: 1), (timer) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final locationData = jsonEncode({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'busName': "1",
    });
    channel.sink.add(locationData);
  });

  channel.stream.listen((message) {
    debugPrint('Received: $message');
  }, onDone: () {
    debugPrint('WebSocket closed');
  }, onError: (error) {
    debugPrint('WebSocket error: $error');
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    startLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OGS BUS CLIENT APP'),
        ),
        body: Center(
            child: Text(
          'Sending Location to Server...',
          style: TextStyle(fontSize: 24),
        )),
      ),
    );
  }

  @override
  void dispose() {
    ForegroundService().stop();
    super.dispose();
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
