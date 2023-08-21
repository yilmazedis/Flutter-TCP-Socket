import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/client.dart';
import '../services/socket_service.dart';
import '../utils/terminal_service.dart';

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key, required this.title, required this.socket});

  final Socket socket;
  final String title;

  @override
  State<TicTacToe> createState() => _TicTacToe();
}

class _TicTacToe extends State<TicTacToe> {
  String _message = "";
  String _selection = "";

  void listenSocket(Socket socket) {
    listenToSocket(socket, (message) {
      _message = message;
    });

    sendMessage(socket: socket, message: constructInput(StringMatcher.namePrefix, "Yilmaz"));
  }

  void _sendSelection() {
    sendMessage(socket: widget.socket, message: _selection);
  }

  Widget onePiece() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        onPressed: _sendSelection,
        child: const Icon(Icons.circle_outlined),
      ),
    );
  }

  Widget ticTacToe() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            onePiece(),
            onePiece(),
            onePiece(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            onePiece(),
            onePiece(),
            onePiece(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            onePiece(),
            onePiece(),
            onePiece(),
          ],
        ),
      ],
    );
  }

  Widget selectLetter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _selection = constructInput(StringMatcher.messagePrefix, "X");
              });
            },
            child: const Icon(Icons.close),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _selection = constructInput(StringMatcher.messagePrefix, "O");
              });
            },
            child: const Icon(Icons.circle_outlined),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    listenSocket(widget.socket);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectLetter(),
            const SizedBox(height: 40),
            ticTacToe(),
            Text(
              deconstructInput(StringMatcher.messagePrefix, _message),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
