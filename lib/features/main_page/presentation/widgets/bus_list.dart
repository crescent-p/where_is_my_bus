import 'package:flutter/material.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/main_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/request_permission.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/tile_view.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class BusList extends StatefulWidget {
  final List<BusCoordinates> busStream;
  final bool permission;
  const BusList({super.key, required this.busStream, required this.permission});

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  @override
  void initState() {
    super.initState();
    // Check for permissions after the widget is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.permission) {
        _navigateToPermissionPopup();
      }
    });
  }

  void _navigateToPermissionPopup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestPermissionPopup(context: context),
      ),
    );
  }

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
      ),
    );
  }
}
