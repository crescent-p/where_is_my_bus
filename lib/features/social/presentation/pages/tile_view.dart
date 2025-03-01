import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class TileView extends StatefulWidget {
  final List<BusCoordinates> busStream;
  const TileView({super.key, required this.busStream});

  @override
  State<TileView> createState() => _TileViewState();
}

class _TileViewState extends State<TileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      body: widget.busStream.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
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
                    "No buses found",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: AppPallete.textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sorry!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.textColor,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: ClampingScrollPhysics(),
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
                        widget.busStream[index].latitude,
                        widget.busStream[index].longitude,
                        bus.location,
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: AppPallete.gradient1,
                    title: Text(
                      "${bus.name} Bus",
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
                          "Confidence: ${bus.confidence}",
                          style: const TextStyle(
                              color: AppPallete.textColor,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last Updated at: ${(bus.lastUpdated.hour % 12).toString().padLeft(2, '0')}:${bus.lastUpdated.minute.toString().padLeft(2, '0')}:${bus.lastUpdated.second.toString().padLeft(2, '0')} ${bus.lastUpdated.hour > 12 ? 'PM' : 'AM'}',
                          style: const TextStyle(
                              color: AppPallete.textColor,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Number of Contributors: ${bus.noOfContributors}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
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
