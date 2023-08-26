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

void showErrorDialog(BuildContext context, String message, Function action) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("You can not do that"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              action();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}