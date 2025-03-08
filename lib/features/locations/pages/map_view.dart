// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:where_is_my_bus/core/constants/constants.dart';
// import 'package:where_is_my_bus/core/theme/colors.dart';
// import 'package:where_is_my_bus/features/locations/bloc/bloc/web_socket_bloc.dart';
// import 'package:widget_to_marker/widget_to_marker.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final Map<String, Marker> _markers = {};
//   final Completer<GoogleMapController> _mapController = Completer();
//   static const LatLng _initialPosition =
//       LatLng(11.318745237278014, 75.93916477476587);

//   Future<BitmapDescriptor> _createBusMarker(String busId, String route) async {
//     try {
//       return await Container(
//         width: 96,
//         height: 96,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Image.asset(
//               "assets/pngs/bus.png",
//               width: 48,
//               height: 48,
//             ),
//             Positioned(
//               bottom: 8,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.7),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   busId,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ).toBitmapDescriptor(
//         logicalSize: const Size(96, 96),
//         imageSize: const Size(192, 192),
//       );
//     } catch (e) {
//       debugPrint("Marker creation error: $e");
//       return BitmapDescriptor.defaultMarker;
//     }
//   }

//   void _updateMarkers(WebSocketMessageReceivedState state) {
//     final marker = Marker(
//       markerId: MarkerId(state.busName),
//       position: state.coordinates,
//       icon: _markers[state.busName]?.icon ?? BitmapDescriptor.defaultMarker,
//       infoWindow: InfoWindow(
//         title: 'Bus ${state.busName}',
//         snippet: 'Last updated: ${DateTime.now().toLocal()}',
//       ),
//     );

//     setState(() {
//       _markers[state.busName] = marker;
//     });
//   }

//   Future<void> _initializeMarkers() async {
//     final initialMarkers = {
//       '1': await _createBusMarker('MBH1', 'Main Route'),
//       '2': await _createBusMarker('MBH2', 'Express Route'),
//       '3': await _createBusMarker('LH1', 'Local Route'),
//     };

//     setState(() {
//       _markers.addAll({
//         for (var entry in initialMarkers.entries)
//           entry.key: Marker(
//             markerId: MarkerId(entry.key),
//             position: _initialPosition,
//             icon: entry.value,
//           )
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeMarkers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocListener<WebSocketBloc, WebSocketState>(
//         listener: (context, state) {
//           if (state is WebSocketMessageReceivedState) {
//             _updateMarkers(state);
//           }
//         },
//         child: BlocBuilder<WebSocketBloc, WebSocketState>(
//           builder: (context, state) {
//             return GoogleMap(
//               onMapCreated: (controller) {
//                 _mapController.complete(controller);
//               },
//               initialCameraPosition: const CameraPosition(
//                 target: _initialPosition,
//                 zoom: 17.0,
//                 // tilt: 90,
//                 bearing: 270,
//               ),
//               mapType: MapType.normal,
//               style: MAPSTYLE.toString(),
//               markers: _markers.values.toSet(),
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/snack_bar.dart';
import 'package:where_is_my_bus/features/locations/bloc/bloc/web_socket_bloc.dart';
import 'package:where_is_my_bus/init_dependencies.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // In your widget's initState
  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    context.read<WebSocketBloc>().add(ConnectWebSocket());
  }

// For cleanup
  @override
  void dispose() {
    context.read<WebSocketBloc>().add(WebSocketDisconnectEvent());
    super.dispose();
  }

  final Map<String, Marker> _markers = {};
  final Completer<GoogleMapController> _mapController = Completer();
  static const LatLng _initialPosition =
      LatLng(11.328645237278014, 75.91916477476587);

  Future<BitmapDescriptor> _createBusMarker(String busId, String route) async {
    try {
      return await Container(
        width: 96,
        height: 96,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/pngs/bus.png",
              width: 48,
              height: 48,
            ),
            Positioned(
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  busId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).toBitmapDescriptor(
        logicalSize: const Size(96, 96),
        imageSize: const Size(192, 192),
      );
    } catch (e) {
      debugPrint("Marker creation error: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  void _updateMarkers(WebSocketMessageReceivedState state) {
    final marker = Marker(
      markerId: MarkerId(state.busName),
      position: state.coordinates,
      icon: _markers[state.busName]?.icon ?? BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Bus ${state.busName}',
        snippet: 'Last updated: ${DateTime.now().toLocal()}',
      ),
    );

    setState(() {
      _markers[state.busName] = marker;
    });
  }

  Future<void> _initializeMarkers() async {
    final initialMarkers = {
      '1': await _createBusMarker('MBH1', 'Main Route'),
      '2': await _createBusMarker('MBH2', 'Express Route'),
      '3': await _createBusMarker('LH1', 'Local Route'),
    };

    setState(() {
      _markers.addAll({
        for (var entry in initialMarkers.entries)
          entry.key: Marker(
            markerId: MarkerId(entry.key),
            position: _initialPosition,
            icon: entry.value,
          )
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<WebSocketBloc, WebSocketState>(
        listener: (context, state) {
          if (state is WebSocketMessageReceivedState) {
            _updateMarkers(state);
          } else if (state is WebSocketFailedState) {
            showSnack(context, "title", "Web Socker Failed",
                ContentType.success, Colors.black);
          }
        },
        child: BlocBuilder<WebSocketBloc, WebSocketState>(
          builder: (context, state) {
            return GoogleMap(
              onMapCreated: (controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: 13.0,
              ),
              mapType: MapType.normal,
              markers: _markers.values.toSet(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            );
          },
        ),
      ),
    );
  }
}
