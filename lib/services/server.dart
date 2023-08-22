import 'dart:io';
import 'dart:typed_data';
import '../models/player.dart';
import 'socket_service.dart';
import '../utils/terminal_service.dart';

Future<void> connectAsServer() async {
  final ip = InternetAddress.anyIPv4;
  final server = await ServerSocket.bind(ip, 3000);
  print("Server is running on: ${ip.address}:3000");
  server.listen((Socket event) {
    handleConnection(event);
  });
}

List<Player> players = [];

void handleConnection(Socket client) {
  printGreen(
    "Connection from ${client.remoteAddress.address}:${client.remotePort}",
  );

  client.listen(
        (Uint8List data) async {
      final message = String.fromCharCodes(data);

      if (message.startsWith(StringMatcher.namePrefix)) {
        for (var player in players) {
          player.socket.write("${deconstructInput(StringMatcher.namePrefix, message)} joined the game");
        }
        players.add(Player(socket: client, username: message, message: ""));
      } else if (message.startsWith(StringMatcher.messagePrefix)) {

        final destructedMessage = deconstructInput(StringMatcher.messagePrefix, message);

        if (destructedMessage == StringMatcher.selectedGameIndex) {
          client.write(selectedGameIndex.toString());
          return;
        }

        for (var player in players) {
          player.socket.write(destructedMessage);
        }
        print(destructedMessage);
      } else {
        print("$message doesn't match");

      }

    }, // handle errors
    onError: (error) {
      print(error);
      client.close();
      players.removeWhere(((element) => element.socket == client));
    },

    // handle the client closing the connection
    onDone: () {
      printRed('Client left');
      client.close();
      players.removeWhere(((element) => element.socket == client));
    },
  );
}
