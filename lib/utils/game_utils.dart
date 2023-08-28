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

void showInfoDialog(BuildContext context, String message, Function action, bool withCancel) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("There is something you need to know!"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              action();
            },
            child: const Text('Ok'),
          ),
          withCancel ?
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ) : Container(),
        ],
      );
    },
  );
}

extension BoolExt on bool? {
  bool isTrue() {
    if (this == null) {
      return false;
    }
    return this!;
  }
}

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const AppButton({super.key, required this.title, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(height: 6.0),
            Text(title),
          ],
        ),
      ),
    );
  }
}
