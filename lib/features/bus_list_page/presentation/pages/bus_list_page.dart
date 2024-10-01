import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as my_user;
import 'package:where_is_my_bus/core/secrets/secrets.dart';
import 'package:where_is_my_bus/features/bus_list_page/data/data_sources/locations_remote_datasource.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/widgets/bus_list.dart';

class BusListPage extends StatefulWidget {
  final my_user.User user;
  const BusListPage({super.key, required this.user});
  static route(my_user.User user) =>
      MaterialPageRoute(builder: (context) => BusListPage(user: user));
  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  @override
  Future<void> init() async {
    bool serviceEnabled;
    LocationPermission permission;
    String _locationMessage = "";
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
        _locationMessage = "Location services are disabled.";
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _locationMessage = "Location permission denied.";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _locationMessage = "Location permissions are permanently denied.";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_locationMessage)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocListener<LocationsBloc, LocationsState>(
        listener: (context, state) {
          if (state is LocationEventFailed) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.message)),
            // );
          }
        },
        child: BlocBuilder<LocationsBloc, LocationsState>(
          builder: (context, state) {
            if (state is LocationsInitial) {
              return CircularProgressIndicator();
            } else if (state is GetCurrentBusLocationsSuccess) {
              return BusList(busStream: state.buses);
            } else {
              return Text("Hi babe");
            }
          },
        ),
      ),
    );
  }
}
