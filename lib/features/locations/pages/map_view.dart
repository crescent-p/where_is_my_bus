import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/snack_bar.dart';
import 'package:where_is_my_bus/features/locations/bloc/bloc/web_socket_bloc.dart';
import 'package:where_is_my_bus/init_dependencies.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MapScreen());
  }

  @override
  State<MapScreen> createState() => _MapScreenState();
}

Future<void> _keepSendingLocation() async {
  while (true) {
    await Future.delayed(Duration(milliseconds: 500));
    Position position = await Geolocator.getCurrentPosition();
    // Send current location to WebSocket Bloc
    if (position != null) {
      serviceLocator<WebSocketBloc>().add(SendLocationToWebSocket(
          latitude: position.latitude,
          longitude: position.longitude,
          name: "1")); // Use the event here
    }
  }
}

void _checkPermission(context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showSnack(context, "Location Disabled", 'Location services are disabled.',
        ContentType.warning, Colors.red); // Corrected to Colors.red
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showSnack(context, "Location Denied", 'Location permissions are denied',
          ContentType.warning, Colors.red); // Corrected to Colors.red
      return;
    }
  }
}

class _MapScreenState extends State<MapScreen> {
  final Map<String, Marker> _markers = {};
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _checkPermission(context);
    _keepSendingLocation();
    context.read<WebSocketBloc>().add(ConnectWebSocket());
  }

  @override
  void dispose() {
    context.read<WebSocketBloc>().add(WebSocketDisconnectEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Text(
          "Sending Data... ",
          style: TextStyle(fontSize: 32),
        )),
      ),
    );
  }
}
