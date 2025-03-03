import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/common/widgets/loading_screen.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/snack_bar.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/loginPage.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/main_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/request_permission.dart';
import 'package:where_is_my_bus/features/social/presentation/widgets/bus_list.dart';
import 'package:where_is_my_bus/init_dependencies.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocationsBloc, LocationsState>(
            listener: (context, state) async {
              if (state is LocationEventFailed) {
                showSnack(
                  context,
                  "Location Event Failed",
                  "Failed to update Location! Please check internet",
                  ContentType.failure,
                  AppPallete.errorColor,
                );
                // } else if (state is UpdateLocationSuccess) {
                // showSnack(
                //   context,
                //   "Update Location Success",
                //   "Cool!",
                //   ContentType.failure,
                //   AppPallete.success,
                // );
              } else if (state is AuthSignOutEvent) {
                Navigator.pushAndRemoveUntil(
                  context,
                  Loginpage.route(),
                  (route) => false,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<LocationsBloc, LocationsState>(
          builder: (context, state) {
            if (state is LocationsInitial || state is LocationLoading) {
              serviceLocator<LocationsBloc>().add(GetBusLocationsEvent());
              return const LoadingScreen();
            } else if (state is GetCurrentBusLocationsSuccess) {
              widget.busStreamCache = state.buses;
              return BusList(
                busStream: state.buses,
                permission: true,
              );
            } else if (state is GetCurrentBusLocationsFailed) {
              return BusList(
                busStream: widget.busStreamCache,
                permission: true,
              );
            } else if (state is LocationPermissionDenied) {
              return RequestPermissionPopup(context: context);
            } else {
              return BusList(
                busStream: widget.busStreamCache,
                permission: true,
              ); // Default state handling
            }
          },
        ),
      ),
    );
  }
}
