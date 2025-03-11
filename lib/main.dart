import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:workmanager/workmanager.dart';

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

@pragma('vm:entry-point') // Required for Flutter 3.1+ or obfuscated apps
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Task executed: $task");
    // Perform your background task here
    startLocation();
    return Future.value(true); // Return true if successful, false otherwise
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().registerOneOffTask("uniqueTaskId", "simpleTask");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Locks portrait mode
  ]).then((_) {
    runApp(MaterialApp(
          home: MyApp(),
          debugShowCheckedModeBanner: false,
        ));
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
