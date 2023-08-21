// Dart client

import 'dart:io';
import 'dart:typed_data';

Future<Socket> connectAsClient() async {
  final socket = await Socket.connect("0.0.0.0", 3000);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
  return socket;
}

void listenToSocket(Socket socket, Function(String) responseHandler) {
  socket.listen(
        (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      responseHandler(serverResponse);
    },
    onError: (error) {
      print(error);
      socket.destroy();
    },
    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );
}