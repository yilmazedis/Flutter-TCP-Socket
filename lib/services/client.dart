// Dart client

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:family_competition/services/socket_service.dart';
import 'package:family_competition/utils/game_utils.dart';
import 'package:family_competition/utils/terminal_service.dart';

Future<Socket> connectAsClient() async {
  final socket = await Socket.connect("0.0.0.0", portNumber);
  printDebug('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
  return socket;
}

void listenToSocket({required Socket socket, bool? isInGame, required Function(String) responseHandler}) {
  socket.listen((Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      responseHandler(serverResponse);
    },
    onError: (error) {
      printDebug(error);
      if (isInGame.isTrue()) {
        printDebug(playerName);
      }
      socket.destroy();
    },
    onDone: () {
      printDebug('Client left.');
      if (isInGame.isTrue()) {
        printDebug(playerName);
      }
      socket.destroy();
    },
  );
}
