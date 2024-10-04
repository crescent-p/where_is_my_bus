import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/map_view.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/tile_view.dart';

class BusList extends StatefulWidget {
  final List<Bus> busStream;

  BusList({required this.busStream});

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [TileView(busStream: widget.busStream)],
            ),
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.list),
                title: const Text("List"),
                selectedColor: Colors.red,
              ),

              // SalomonBottomBarItem(
              //   icon: const Icon(Icons.map),
              //   title: const Text("Map"),
              //   selectedColor: Colors.red,
              // ),
            ],
          )),
    );
  }
}
