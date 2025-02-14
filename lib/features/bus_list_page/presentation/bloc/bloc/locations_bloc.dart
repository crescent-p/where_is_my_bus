import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/usecases/get_bus_locations_usecase.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/usecases/update_current_location_usecase.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final GetBusLocationsUsecase _getBusLocationsUsecase;
  // final UpdateCurrentLocationUsecase _updateCurrentLocationUsecase;
  LocationsBloc({
    required GetBusLocationsUsecase getBusLocationsUsecase,
    // required UpdateCurrentLocationUsecase updateCurrentLocationUsecase,
  })  : _getBusLocationsUsecase = getBusLocationsUsecase,
        // _updateCurrentLocationUsecase = updateCurrentLocationUsecase,
        super(LocationsInitial()) {
    on<LocationsEvent>((event, emit) {});
    on<GetBusLocationsEvent>(_getBusLocationsEvent);
    // on<UpdateCurrentLocationEvent>(_updateCurrentLocation);
    on<PermissionDialogShownEvent>(_permissionDialogShownEvent);
  }

  Future<void> _permissionDialogShownEvent(
      PermissionDialogShownEvent event, Emitter<LocationsState> emit) async {
    return emit(PermissionDialogShown());
  }

  Future<void> _getBusLocationsEvent(
      GetBusLocationsEvent event, Emitter<LocationsState> emit) async {
    if (serviceLocator<LocationsBloc>().state is LocationPermissionDenied) {
      return;
    }
    // return;
    final res = await _getBusLocationsUsecase(NoParams());
    res.fold((l) => emit(LocationEventFailed(message: l.message)),
        (r) => emit(GetCurrentBusLocationsSuccess(buses: r)));
  }

  // Future<void> _updateCurrentLocation(
  //     UpdateCurrentLocationEvent event, Emitter<LocationsState> emit) async {
  //   final res = await _updateCurrentLocationUsecase(NoParams());
  //   res.fold(
  //       (onLeft) => emit(LocationPermissionDenied()),
  //       (onRight) => emit(
  //           UpdateLocationSuccess(message: "Updated Location Successfully!")));
  // }
}
