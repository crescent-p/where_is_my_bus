import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

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
        actions: [
          IconButton(
              onPressed: () {
                serviceLocator<AuthBloc>().add(AuthSignOutEvent());
              },
              icon: const Icon(
                Icons.logout,
                color: AppPallete.gradient3,
              ))
        ],
        backgroundColor: AppPallete.gradient2,
        title: const Text(
          'Bus List',
          style: TextStyle(
            color: AppPallete.gradient3,
            fontSize: 32,
            decorationThickness: BorderSide.strokeAlignCenter,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: AppPallete.backgroundColor,
      body: widget.busStream.isEmpty
          ? Column(
              children: [
                Lottie.asset("assets/animations/monkey.json"),
                const Flex(direction: Axis.vertical),
                const Text(
                  textAlign: TextAlign.center,
                  "Oops I couldn't find any buses Sorry!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.textColor),
                )
              ],
            )
          : ListView.builder(
              itemCount: widget.busStream.length,
              itemBuilder: (context, index) {
                final bus = widget.busStream[index];
                return Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  margin: EdgeInsetsGeometry.lerp(
                      EdgeInsets.all(8), EdgeInsets.zero, 0.5),
                  child: ListTile(
                    onTap: () {
                      MapsLauncher.launchCoordinates(
                          widget.busStream[index].coordinates.x,
                          widget.busStream[index].coordinates.y,
                          "Bus Number ${index + 1}");
                    },
                    shape: ShapeBorder.lerp(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      1, // This is the interpolation factor
                    ),
                    tileColor: AppPallete.gradient1,
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      'Bus ${index + 1}',
                      style: const TextStyle(
                        color: AppPallete.gradient2,
                        fontSize: 24,
                        decorationThickness: BorderSide.strokeAlignCenter,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      '${bus.location}Last Updated at: ${(bus.lastUpdated.hour % 12).toString().padLeft(2, '0')}:${bus.lastUpdated.minute.toString().padLeft(2, '0')}:${bus.lastUpdated.second.toString().padLeft(2, '0')} ${bus.lastUpdated.hour > 12 ? 'PM' : 'AM'}',
                      style: const TextStyle(
                        color: AppPallete.textColor,
                        fontSize: 12,
                        decorationThickness: BorderSide.strokeAlignCenter,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
