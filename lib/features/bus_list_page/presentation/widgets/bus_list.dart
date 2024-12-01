import 'package:flutter/material.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/tile_view.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class BusList extends StatefulWidget {
  final List<BusCoordinates> busStream;

  const BusList({super.key, required this.busStream});

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        serviceLocator<LocationsBloc>().add(GetBusLocationsEvent());
        return;
      },
      child: TileView(
        busStream: widget.busStream,
      ),
    ));
  }
}
