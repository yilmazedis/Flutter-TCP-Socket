import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import '../services/client.dart';
import '../services/socket_service.dart';
import '../utils/game_utils.dart';
import '../utils/terminal_service.dart';

class TicTacToe extends StatefulWidget {

  const TicTacToe({super.key, required this.socket});

  final Socket socket;

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToe> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late bool _gameOver;
  int _gamesPlayed = 0;
  int initRow = 3;
  int initCol = 3;
  String _matchResult = "";
  TextEditingController controller = TextEditingController();

  bool isEditing = true;

  @override
  void initState() {
    super.initState();
    listenSocket(widget.socket);
    _initializeGame();
  }

  void listenSocket(Socket socket) {
    listenToSocket(socket, (message) {
      setState(() {
        final newMessage = deconstructInput(StringMatcher.messagePrefix, message);

        final state = deConstruct(newMessage);
        if (state.currentPlayer.isEmpty) {
          return;
        }
        _board[state.row][state.col] = state.currentPlayer;
        _gamesPlayed++;
        if (_checkWin(state.row, state.col, state.currentPlayer)) {
          _matchResult = 'Player ${state.currentPlayer} wins!';
          print(_matchResult);
          _gameOver = true;
        } else if (_gamesPlayed >= initRow * initCol) {
          _matchResult = "Evenly";
          _gameOver = true;
        }
      });
    });
    sendMessage(socket: socket, message: constructInput(StringMatcher.namePrefix, "Yilmaz"));
  }

  void _initializeGame() {
    _board = List.generate(initRow, (_) => List.generate(initCol, (_) => ''));
    _currentPlayer = 'O';
    _gamesPlayed = 0;
    _gameOver = false;
  }

  DeconstructedMessage deConstruct(String message) {
    List<String> parts = message.split(',');
    if (parts.length == 3) {
      int? row = int.tryParse(parts[0]);
      int? col = int.tryParse(parts[1]);
      if (row != null && col != null) {
        return DeconstructedMessage(row, col, parts[2].trim());
      }
    }
    return DeconstructedMessage(-1, -1, ''); // Return an invalid value if deconstruction fails
  }

  String constructMessage(int row, int col, String currentPlayer) {
    return "$row,$col, $currentPlayer";
  }

  void _makeMove(int row, int col) {
    if (!_gameOver && _board[row][col] == '') {
      setState(() {
        final state = constructMessage(row, col, _currentPlayer);
        sendMessage(socket: widget.socket, message: constructInput(StringMatcher.messagePrefix, state));
      });
    }
  }

  bool _checkWin(int row, int col, String currentPlayer) {
    return (_board[row][0] == currentPlayer &&
        _board[row][1] == currentPlayer &&
        _board[row][2] == currentPlayer) ||
        (_board[0][col] == currentPlayer &&
            _board[1][col] == currentPlayer &&
            _board[2][col] == currentPlayer) ||
        (row == col &&
            _board[0][0] == currentPlayer &&
            _board[1][1] == currentPlayer &&
            _board[2][2] == currentPlayer) ||
        (row + col == 2 &&
            _board[0][2] == currentPlayer &&
            _board[1][1] == currentPlayer &&
            _board[2][0] == currentPlayer);
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  Widget _buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => _makeMove(row, col),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        alignment: Alignment.center,
        child: Text(
          _board[row][col],
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent going back when the back button is pressed
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Hide back button
          title: Text('Tic Tac Toe'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                showQuitGameDialog(context, () async {
                  await widget.socket.close().then((value) {
                    Navigator.pop(context);
                  });
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                const SizedBox(height: 20,),

                squareTextField(controller, isEditing, () {
                  setState(() {
                    _currentPlayer = controller.text;
                    isEditing = false;
                  });
                }),

                const SizedBox(height: 20,),

                for (int row = 0; row < 3; row++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int col = 0; col < 3; col++)
                        _buildCell(row, col),
                    ],
                  ),
                if (_gameOver)
                  Text(
                    _matchResult,
                    style: TextStyle(fontSize: 24),
                  ),
                SizedBox(height: 40,)
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: UniqueKey(),
          onPressed: _gameOver ? _resetGame : null,
          backgroundColor: Colors.green.withOpacity(_gameOver ? 1.0 : 0.5),
          child: const Icon(Icons.lock_reset),
        ),
      ),
    );
  }
}

class DeconstructedMessage {
  final int row;
  final int col;
  final String currentPlayer;

  DeconstructedMessage(this.row, this.col, this.currentPlayer);
}

Widget squareTextField(
    TextEditingController controller, bool isEnabled, VoidCallback onEditingComplete) {
  return SizedBox(
    width: 100,
    height: 100,

    child: TextField(
      controller: controller,
      enabled: isEnabled,
      maxLength: 1,
      style: const TextStyle(fontSize: 48),
      onChanged: (value) {
        // You can perform any action here when the text changes
      },
      textCapitalization: TextCapitalization.characters, // Force uppercase
      onEditingComplete: onEditingComplete,
      textAlign: TextAlign.center,
      maxLengthEnforcement: MaxLengthEnforcement.enforced, // Prevent cursor overflow
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(0),
        border: OutlineInputBorder(),
      ),
    ),
  );
}