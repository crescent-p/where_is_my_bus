part of 'web_socket_bloc.dart';

@immutable
sealed class WebSocketEvent {}

class ConnectWebSocket extends WebSocketEvent {}

class ConnectWebStartListeningEvent extends WebSocketEvent {}

class WebSocketDisconnectEvent extends WebSocketEvent {}


class SendMessageEvent extends WebSocketEvent {
  final String message;
  SendMessageEvent(this.message);
}

class MessageReceivedEvent extends WebSocketEvent {
  final String message;
  MessageReceivedEvent(this.message);
}
