import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    // Provide a default location (e.g., London)
    LatLng initialCenter = const LatLng(51.5, -0.09);

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {},
        initialCameraPosition: CameraPosition(
          target: initialCenter,
          zoom: 13.0,
        ),
        mapType: MapType.normal,
      ),
    );
  }
}
