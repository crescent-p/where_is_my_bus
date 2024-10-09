import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class TileView extends StatefulWidget {
  final List<Bus> busStream;
  const TileView({super.key, required this.busStream});

  @override
  State<TileView> createState() => _TileViewState();
}

class _TileViewState extends State<TileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                serviceLocator<AuthBloc>().add(AuthSignOutEvent());
              },
              icon: const Icon(
                Icons.logout,
                color: AppPallete.whiteColor,
              ))
        ],
        backgroundColor: AppPallete.gradient2,
        title: const Text(
          'Bus List',
          style: TextStyle(
            color: AppPallete.whiteColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: AppPallete.backgroundColor,
      body: widget.busStream.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset(
                    "assets/animations/monkey.json",
                    height: 400,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Oops! Couldn't find any buses. Sorry!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.textColor,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: widget.busStream.length,
              itemBuilder: (context, index) {
                final bus = widget.busStream[index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: ListTile(
                    onTap: () {
                      MapsLauncher.launchCoordinates(
                        widget.busStream[index].coordinates.x,
                        widget.busStream[index].coordinates.y,
                        "Bus Number ${index + 1}",
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: AppPallete.gradient1,
                    title: Text(
                      'Bus ${index + 1}',
                      style: const TextStyle(
                        color: AppPallete.whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          bus.location,
                          style: const TextStyle(
                            color: AppPallete.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last Updated at: ${(bus.lastUpdated.hour % 12).toString().padLeft(2, '0')}:${bus.lastUpdated.minute.toString().padLeft(2, '0')}:${bus.lastUpdated.second.toString().padLeft(2, '0')} ${bus.lastUpdated.hour > 12 ? 'PM' : 'AM'}',
                          style: const TextStyle(
                              color: AppPallete.textColor,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.directions_bus,
                      color:
                          DateTime.now().difference(bus.lastUpdated).inMinutes >
                                  5
                              ? AppPallete.errorColor
                              : AppPallete.success,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
