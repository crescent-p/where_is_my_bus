part of 'web_socket_bloc.dart';

@immutable
sealed class WebSocketState {}

class WebSocketInitialState extends WebSocketState {}

class WebSocketConnectedState extends WebSocketState {}

class WebSocketMessageReceivedState extends WebSocketState {
  final String busName;
  final LatLng coordinates;
  WebSocketMessageReceivedState(this.busName, this.coordinates);
}
