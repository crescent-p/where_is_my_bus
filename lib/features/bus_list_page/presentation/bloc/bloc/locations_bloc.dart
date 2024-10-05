import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/usecases/get_bus_locations_usecase.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/usecases/update_current_location_usecase.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  Timer? _getListtimer;
  final GetBusLocationsUsecase _getBusLocationsUsecase;
  final UpdateCurrentLocationUsecase _updateCurrentLocationUsecase;
  LocationsBloc({
    required GetBusLocationsUsecase getBusLocationsUsecase,
    required UpdateCurrentLocationUsecase updateCurrentLocationUsecase,
  })  : _getBusLocationsUsecase = getBusLocationsUsecase,
        _updateCurrentLocationUsecase = updateCurrentLocationUsecase,
        super(LocationsInitial()) {
    _getListtimer =
        Timer.periodic(Duration(seconds: UPDATE_LIST_INTERVAL), (timer) {
      add(GetBusLocationsEvent());
    });
    on<LocationsEvent>((event, emit) {});
    on<GetBusLocationsEvent>(_getBusLocationsEvent);
    on<UpdateCurrentLocationEvent>(_updateCurrentLocation);
  }

  Future<void> _getBusLocationsEvent(
      GetBusLocationsEvent event, Emitter<LocationsState> emit) async {
    final res = await _getBusLocationsUsecase(NoParams());
    res.fold((l) => emit(LocationEventFailed(message: l.message)),
        (r) => emit(GetCurrentBusLocationsSuccess(buses: r)));
  }

  Future<void> _updateCurrentLocation(
      UpdateCurrentLocationEvent event, Emitter<LocationsState> emit) async {
    final res = await _updateCurrentLocationUsecase(NoParams());
    // res.fold((l) => emit(LocationEventFailed(message: l.message)),
    //     (r) => emit(UpdateLocationSuccess(message: r)));
  }
}
