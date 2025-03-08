import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketManager {
  late IOWebSocketChannel channel;

  void connect() {
    channel = IOWebSocketChannel.connect(
        Uri.parse('ws://68.233.101.85/locations/subscribe'));
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

  WebSocketBloc() : super(WebSocketInitialState()) {
    _webSocketManager.connect();

    //Moved here
    _webSocketManager.listen((message) {
      add(MessageReceivedEvent(message));
    });

    on<ConnectWebSocket>((event, emit) {
      emit(WebSocketConnectedState());
    });

    on<SendMessageEvent>((event, emit) {
      _webSocketManager.sendMessage(event.message);
    });

    on<MessageReceivedEvent>((event, emit) {
      final data = jsonDecode(event.message);
      final latitude = data['latitude'];
      final longitude = data['longitude'];
      final busName = data['busName'];
      final position = LatLng(latitude, longitude);
      emit(WebSocketMessageReceivedState(event.message, position));
    });
  }

  @override
  Future<void> close() {
    _webSocketManager.close();
    return super.close();
  }
}
