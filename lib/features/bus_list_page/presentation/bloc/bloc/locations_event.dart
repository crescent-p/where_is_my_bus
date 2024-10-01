part of 'locations_bloc.dart';

@immutable
sealed class LocationsEvent {}

class GetBusLocationsEvent extends LocationsEvent {}

class UpdateCurrentLocationEvent extends LocationsEvent {}
