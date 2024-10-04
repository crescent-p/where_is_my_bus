
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Example')),
      body: FlutterMap(
        mapController: MapController(),
        
        options: MapOptions(
          initialCameraFit: const CameraFit.coordinates(
              coordinates: [LatLng(11, 72)]), // Center of the map
          minZoom: 13.0, // Initial zoom level
        ),
        children: const [],
      ),
    );
  }
}
