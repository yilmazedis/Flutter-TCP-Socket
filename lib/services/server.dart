import 'dart:io';
import 'dart:typed_data';
import 'package:family_competition/games/tic_tac_toe.dart';
import '../models/game.dart';
import '../models/player.dart';
import 'socket_service.dart';
import '../utils/terminal_service.dart';

Future<void> connectAsServer() async {
  final ip = InternetAddress.anyIPv4;
  final server = await ServerSocket.bind(ip, 3000);
  printDebug("Server is running on: ${ip.address}:3000");
  server.listen((Socket event) {
    handleConnection(event);
  });
}

List<Player> players = [];

List<Game> games = [
  Game(name: "Tic Tac Toe", userLimit: 2, gameFactory: (socket) => TicTacToe(socket: socket)),
  Game(name: "Minesweeper", userLimit: 2, gameFactory: (socket) => TicTacToe(socket: socket)),
  Game(name: "Hangman", userLimit: 2, gameFactory: (socket) => TicTacToe(socket: socket)),
];

void handleConnection(Socket client) {
  printGreen(
    "Connection from ${client.remoteAddress.address}:${client.remotePort}",
  );

  client.listen((Uint8List data) {
      final message = String.fromCharCodes(data);

      /// ******* ///
      /// Prompts ///
      /// Add New Player
      _newPlayer(socket: client, message: message);

      /// Add New Message
      _newMessage(message: message);

      /// getSelectedGameIndex
      _getSelectedGameIndex(socket: client, message: message);

      /// playerNumberInGame
      _getPlayerNumberInGame(socket: client, message: message);

    },

    // handle errors
    onError: (error) {
      printDebug(error);
      client.close();
      _handleIfPlayerLeft(client);
    },

    // handle the client closing the connection
    onDone: () {
      printDebug('Client left');
      client.close();
      _handleIfPlayerLeft(client);
    },
  );
}

void _handleIfPlayerLeft(Socket client) {
  players.removeWhere(((element) {
    if (element.socket == client) {
      activePlayer--;
      return true;
    }
    return false;
  }));
}

void _newPlayer({required Socket socket ,required String message}) {
  if (!message.startsWith(StringMatcher.namePrefix)) { return; }

  final input = deconstructInput(StringMatcher.namePrefix, message);
  activePlayer++;
  players.add(Player(socket: socket, username: input, message: ""));
  for (var player in players) {
    player.socket.write("${deconstructInput(StringMatcher.namePrefix, input)} joined the game");
  }
}

void _newMessage({required String message}) {
  if (!message.startsWith(StringMatcher.messagePrefix)) { return; }

  final input = deconstructInput(StringMatcher.messagePrefix, message);
  for (var player in players) {
    player.socket.write(input);
    printDebug(input);
  }
}

void _getSelectedGameIndex({required Socket socket, required String message}) {
  if (message != StringMatcher.selectedGameIndexPrefix) { return; }
  final output = constructInput(StringMatcher.selectedGameIndexPrefix, selectedGameIndex.toString());
  socket.write(output);
}

void _getPlayerNumberInGame({required Socket socket, required String message}) {
  if (message != StringMatcher.activePlayerPrefix) { return; }

  final output = constructInput(StringMatcher.activePlayerPrefix, activePlayer.toString());
  socket.write(output);
}