import 'package:family_competition/games/tic_tac_toe.dart';
import 'package:flutter/material.dart';
import '../games/test_game.dart';
import '../services/client.dart';
import '../services/socket_service.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  final List<String> gameNames = ['Tic Tac Toe', 'Test Game', 'Test Game']; // List of game names


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game List'),
      ),
      body: ListView.builder(
        itemCount: gameNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(gameNames[index]),
            onTap: () {
              selectedGameIndex = index;
              navigateToGamePage(context);
            },
          );
        },
      ),
    );
  }
}

void navigateToGamePage(BuildContext context) {
  // Connect As Client
  connectAsClient().then((socket) {

    // Send message to ask selected game
    sendMessage(socket: socket, message: constructInput(StringMatcher.messagePrefix, StringMatcher.selectedGameIndex));

    // Wait for server to send you selected game index
    listenToSocket(socket, (message) {
      socket.flush();
      socket.close();
      selectedGameIndex = int.parse(message);

      connectAsClient().then((newSocket) {
        switch (selectedGameIndex) {
          case 0:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TicTacToe(socket: newSocket)));
          case 1:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TestGame(socket: newSocket)));
          default:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TestGame(socket: newSocket)));
        }
      });
    });
  });
}
