import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;


  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
     _socket = IO.io(
        'https://band-name-server-flutter.herokuapp.com',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .build());
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('new-message', (payload) {
    //   print('new message');
    //   print(payload.containsKey('name') ? payload['name'] : null);
    //   print(payload.containsKey('message') ? payload['message'] : null);
    // });
  }
}
