import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketManager {
  late IOWebSocketChannel channel;

  Future<void> connect() async {
    channel = await IOWebSocketChannel.connect(
        Uri.parse('ws://68.233.101.85/locations/send'));
  }

  void listen(Function(dynamic) onMessage) {
    channel.stream.listen(
      (message) {
        onMessage(message);
      },
      onError: (error) {
        // Handle errors
        print('WebSocket error: $error');
      },
      onDone: () {
        // Handle connection closure
        print('WebSocket connection closed');
      },
    );
  }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void close() {
    channel.sink.close();
  }
}

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketManager _webSocketManager = WebSocketManager();
  StreamSubscription? _messageSubscription;

  WebSocketBloc() : super(WebSocketInitialState()) {
    on<ConnectWebSocket>(_connectWebSocket);
    on<MessageReceivedEvent>(_handleMessage);
    on<WebSocketDisconnectEvent>(_disconnect);
    on<SendLocationToWebSocket>(_sendData);
  }

  Future<void> _sendData(
    SendLocationToWebSocket event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      print(jsonEncode({
        'latitude': event.latitude,
        'longitude': event.longitude,
        'busName': event.name.toString()
      }));
      _webSocketManager.sendMessage(jsonEncode({
        'latitude': event.latitude,
        'longitude': event.longitude,
        'busName': event.name.toString()
      }));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _connectWebSocket(
    ConnectWebSocket event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      emit(WebSocketConnectingState());
      await _webSocketManager.connect();

      _messageSubscription = _webSocketManager.channel.stream.listen(
        (message) => add(MessageReceivedEvent(message)),
        onError: (error) =>
            emit(WebSocketErrorState(message: error.toString())),
        onDone: () => emit(WebSocketDisconnectedState()),
      );
      emit(WebSocketConnectedState());
    } catch (e, stackTrace) {
      add(ConnectWebSocket());
      emit(
        WebSocketFailedState(
          message: 'Connection failed: ${e.toString()}',
        ),
      );
      addError(e, stackTrace);
    }
  }

  void _handleMessage(
    MessageReceivedEvent event,
    Emitter<WebSocketState> emit,
  ) {
    try {
      final data = jsonDecode(event.message);
      final position = LatLng(data['latitude'], data['longitude']);
      emit(WebSocketMessageReceivedState(data['busName'], position));
    } catch (e) {
      emit(WebSocketErrorState(
          message: 'Message parsing failed: ${e.toString()}'));
    }
  }

  Future<void> _disconnect(
    WebSocketDisconnectEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    await _messageSubscription?.cancel();
    _webSocketManager.close();
    emit(WebSocketDisconnectedState());
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _webSocketManager.close();
    return super.close();
  }
}
