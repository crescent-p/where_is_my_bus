part of 'web_socket_bloc.dart';

@immutable
sealed class WebSocketState {}

class WebSocketInitialState extends WebSocketState {}

class WebSocketConnectedState extends WebSocketState {}

class WebSocketConnectingState extends WebSocketState {}

class WebSocketDisconnectedState extends WebSocketState {}

class WebSocketErrorState extends WebSocketState {
  final String message;
  WebSocketErrorState({required this.message});
}

class WebSocketFailedState extends WebSocketState {
  final String message;

  WebSocketFailedState({required this.message});
}

class WebSocketMessageReceivedState extends WebSocketState {
  final String busName;
  final LatLng coordinates;
  WebSocketMessageReceivedState(this.busName, this.coordinates);
}
