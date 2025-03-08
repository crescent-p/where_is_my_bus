part of 'web_socket_bloc.dart';

@immutable
sealed class WebSocketEvent {}

class ConnectWebSocket extends WebSocketEvent {}

class ConnectWebStartListeningEvent extends WebSocketEvent {}

class WebSocketDisconnectEvent extends WebSocketEvent {}

class SendLocationToWebSocket extends WebSocketEvent {
  final double latitude;
  final double longitude;
  final String name;

  SendLocationToWebSocket({required this.latitude, required this.longitude, required this.name});
}

class SendMessageEvent extends WebSocketEvent {
  final String message;
  SendMessageEvent(this.message);
}

class MessageReceivedEvent extends WebSocketEvent {
  final String message;
  MessageReceivedEvent(this.message);
}
