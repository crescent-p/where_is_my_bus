part of 'locations_bloc.dart';

@immutable
sealed class LocationsState {}

final class LocationsInitial extends LocationsState {}

final class UpdateLocationSuccess extends LocationsState {
  final String message;

  UpdateLocationSuccess({required this.message});
}

final class GetCurrentBusLocationsSuccess extends LocationsState {
  final List<Bus> buses;
  GetCurrentBusLocationsSuccess({required this.buses});
}

final class LocationLoading extends LocationsState {}

class LocationEventFailed extends LocationsState {
  final String message;
  LocationEventFailed({required this.message});
}

class LocationPermissionDenied extends LocationsState {}
