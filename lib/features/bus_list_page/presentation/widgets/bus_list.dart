import 'package:flutter/material.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/tile_view.dart';

class BusList extends StatefulWidget {
  final List<Bus> busStream;

  const BusList({super.key, required this.busStream});

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TileView(
      busStream: widget.busStream,
    ));
  }
}
