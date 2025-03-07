import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_is_my_bus/features/locations/bloc/bloc/web_socket_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  final LatLng defalut = LatLng(11.321973, 75.935386);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketConnectedState) {
            return GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                zoom: 13.0,
                target: LatLng(11.321973, 71.935386),
              ),
              mapType: MapType.normal,
              markers: _markers,
            );
          } else if (state is WebSocketMessageReceivedState) {
            _updateCameraPosition(state.coordinates, state.busName);
            _markers.add(Marker(
              position: state.coordinates,
              markerId: MarkerId("haha"),
            ));
            return GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                zoom: 13.0,
                target: state.coordinates,
              ),
              mapType: MapType.hybrid,
              markers: _markers,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void _updateCameraPosition(LatLng coordinates, String busName) async {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: coordinates,
            zoom: 16.0,
          ),
        ),
      );
      _addMarker(coordinates, busName);
    }
  }

  void _addMarker(LatLng coordinates, String busName) {
    setState(() {
      _markers.clear(); // Clear previous markers if needed
      _markers.add(
        Marker(
          markerId: MarkerId(busName),
          position: coordinates,
          infoWindow: InfoWindow(title: busName),
        ),
      );
    });
  }
}
