import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  WebSocketChannel? _channel;
  bool isConnected = false;
  Stream get messageStream => _channel!.stream;

  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      isConnected = true;
      log('Connected to WebSocket at $url');
    } catch (e) {
      isConnected = false;
      log('Error connecting to WebSocket: $e');
    }
  }

  void sendCommand(String command) {
    if (isConnected && _channel != null) {
      _channel!.sink.add(command);
      log('Sent command: $command');
    } else {
      log('Cannot send command, not connected to WebSocket.');
    }
  }

  void disconnect() {
    if (isConnected && _channel != null) {
      _channel!.sink.close();
      isConnected = false;
      log('Disconnected from WebSocket.');
    } else {
      log('Cannot disconnect, not connected to WebSocket.');
    }
  }
}
