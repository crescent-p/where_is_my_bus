import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/features/locations/bloc/bloc/web_socket_bloc.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';

class BusListPage extends StatefulWidget {
  List<BusCoordinates> busStreamCache = [];
  BusListPage({super.key});
  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OGS_THEME.white,
      body: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketConnectedState) {
            return Text('Connected to WebSocket');
          } else if (state is WebSocketMessageReceivedState) {
            return Text('Received message: ${state.busName}');
          }
          return Text('Connecting...');
        },
      ),
    );
  }
}
