import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';

class TileView extends StatefulWidget {
  List<Bus> busStream;
  TileView({super.key, required this.busStream});

  @override
  State<TileView> createState() => _TileViewState();
}

class _TileViewState extends State<TileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus List'),
      ),
      body: ListView.builder(
        itemCount: widget.busStream.length,
        itemBuilder: (context, index) {
          final bus = widget.busStream[index];

          return ListTile(
            title: Text('Bus ${index + 1}'),
            subtitle:
                Text('Coordinates: (${bus.location}, ${bus.lastUpdated})'),
          );
        },
      ),
    );
  }
}
