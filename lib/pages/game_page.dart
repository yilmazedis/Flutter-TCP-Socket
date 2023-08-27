import 'package:flutter/material.dart';
import '../services/client.dart';
import '../services/server.dart';
import '../services/socket_service.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

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
        itemCount: games.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(games[index].name),
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

void navigateToGamePage(BuildContext context, [Function(String)? errorMessage]) {
  // Connect As Client
  connectAsClient().then((socket) {

    // Required Information
    sendMessage(socket: socket, message: StringMatcher.selectedGameIndexPrefix);

    // Wait for server to send you selected game index
    listenToSocket(socket, (message) async {

      if (message.startsWith(StringMatcher.selectedGameIndexPrefix)) {
        final input = deconstructInput(StringMatcher.selectedGameIndexPrefix, message);
        selectedGameIndex = int.parse(input);

        /// second option
        sendMessage(socket: socket, message: StringMatcher.activePlayerPrefix);
        return;
      } else if (message.startsWith(StringMatcher.activePlayerPrefix)) {
        final input = deconstructInput(StringMatcher.activePlayerPrefix, message);
        activePlayer = int.parse(input);
        if (activePlayer >= games[selectedGameIndex].userLimit) {
          await socket.close();
          if (errorMessage != null) {
            errorMessage("${games[selectedGameIndex].name} has been playing with ${games[selectedGameIndex].userLimit}");
          }
          return;
        }
      }
      await socket.close();
      // Start Game Client
      connectAsClient().then((newSocket) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => games[selectedGameIndex].createGameWidget(socket: newSocket)));
      });
    });
  });
}
