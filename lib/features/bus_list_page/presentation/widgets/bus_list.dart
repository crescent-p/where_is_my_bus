import 'package:flutter/material.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';

class BusList extends StatelessWidget {
  final List<Bus> busStream;

  BusList({required this.busStream});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bus List'),
        ),
        body: ListView.builder(
          itemCount: busStream.length,
          itemBuilder: (context, index) {
            final bus = busStream[index];

            return ListTile(
              title: Text('Bus ${index + 1}'),
              subtitle: Text(
                  'Coordinates: (${bus.coordinates.x}, ${bus.coordinates.y})'),
            );
          },
        ),
      ),
    );
  }
}
