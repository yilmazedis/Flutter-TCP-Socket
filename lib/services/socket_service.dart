import 'dart:io';

enum SocketAction { username, message, unknown }

int selectedGameIndex = 0;
int activePlayer = 0;
String playerName = "No Name";
int portNumber = 3000;

void sendMessage({required Socket socket, required String message}) {
  socket.write(message);
}

String constructInput(String prefix, String content) {
  return "$prefix$content";
}

String deconstructInput(String prefix, String input) {
  if (input.startsWith(prefix)) {
    return input.substring(prefix.length);
  } else {
    return input;
  }
}

class StringMatcher {
  static const String namePrefix = "${PromptNames.name}:";
  static const String messagePrefix = "${PromptNames.message}:";

  static const String selectedGameIndexPrefix = "${PromptNames.selectedGameIndex}:";
  static const String activePlayerPrefix= "${PromptNames.activePlayer}:";
}

class PromptNames {
  static const String name = "name";
  static const String message = "message";

  static const String selectedGameIndex = "selectedGameIndex";
  static const String activePlayer= "activePlayer";
}