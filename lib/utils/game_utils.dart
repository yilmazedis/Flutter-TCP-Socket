import 'package:flutter/material.dart';

void showQuitGameDialog(BuildContext context, Function quit) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('You are leaving the game'),
        content: const Text('I hope you had fun of this game 😊'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              quit();
            },
            child: const Text('Quit'),
          ),
        ],
      );
    },
  );
}