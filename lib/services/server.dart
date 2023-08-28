import 'dart:io';
import 'dart:typed_data';
import 'package:family_competition/games/tic_tac_toe.dart';
import '../models/game.dart';
import '../models/player.dart';
import 'socket_service.dart';
import '../utils/terminal_service.dart';

Future<void> connectAsServer() async {
  final ip = InternetAddress.anyIPv4;
  final server = await ServerSocket.bind(ip, portNumber);
  printDebug("Server is running on: ${ip.address}:$portNumber");
  server.listen((Socket event) {
    handleConnection(event);
  },

  // handle errors
  onError: (error) {
    printDebug(error);
    server.close();
  },

  // handle the client closing the connection
  onDone: () {
    printDebug('Server Left');
    server.close();
  });
}

List<Player> players = [];

List<Game> games = [
  Game(name: "Tic Tac Toe", userLimit: 2, gameFactory: (socket) => TicTacToe(socket: socket)),
  Game(name: "Minesweeper", userLimit: 2, gameFactory: (socket) => TicTacToe(socket: socket)),
  Game(name: "Hangman", userLimit: 2, gameFactory: (socket) => TicTacToe(socket: socket)),
];

void handleConnection(Socket client) {
  printDebug("Connection from ${client.remoteAddress.address}:${client.remotePort}",);

  client.listen((Uint8List data) {
      final message = String.fromCharCodes(data);

      /// read and split prompt
      List<String> prompt = message.split(":").where((part) => part.isNotEmpty).toList();

      /// fetch function
      String functionName = prompt[0];
      final function = promptsMap[functionName];
      if (function == null) {
        printDebug("Function '$functionName' not found.");
        return;
      }

      /// **************** ///
      /// Run Instructions ///
      switch (prompt.length) {
        case 1:
          function(socket: client);
          break;
        case 2:
          function(socket: client, input: prompt[1]);
          break;
      }
    },

    // handle errors
    onError: (error) {
      printDebug(error);
      client.close();
      _handleIfPlayerLeft(client);
      printDebug("Total player number is ${players.length}");
    },

    // handle the client closing the connection
    onDone: () {
      printDebug('Client left');
      client.close();
      _handleIfPlayerLeft(client);
      printDebug("Total player number is ${players.length}");
    },
  );
}

void _handleIfPlayerLeft(Socket client) {
  players.removeWhere(((element) {
    if (element.socket == client) {
      activePlayer--;
      printDebug("Total player number is ${element.username}");
      return true;
    }
    return false;
  }));
}

final promptsMap = {
  PromptNames.name: _newPlayer,
  PromptNames.message: _newMessage,
  PromptNames.selectedGameIndex: _getSelectedGameIndex,
  PromptNames.activePlayer: _getActivePlayer,
};

void _newPlayer({required Socket socket, required String input}) {
  activePlayer++;
  /// TODO: fix activePlayer with Player
  players.add(Player(socket: socket, username: input));
  printDebug("Total player number is ${players.length}");
  for (var player in players) {
    /// TODO: fix playerName with constructInput
    player.socket.write("$input joined the game");
  }
}

void _newMessage({required Socket socket, required String input}) {
  for (var player in players) {
    player.socket.write(input);
    printDebug(input);
  }
}

void _getSelectedGameIndex({required Socket socket}) {
  final output = constructInput(StringMatcher.selectedGameIndexPrefix, selectedGameIndex.toString());
  socket.write(output);
}

void _getActivePlayer({required Socket socket}) {
  final output = constructInput(StringMatcher.activePlayerPrefix, activePlayer.toString());
  socket.write(output);
}