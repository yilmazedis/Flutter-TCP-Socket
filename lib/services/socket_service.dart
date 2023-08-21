import 'dart:io';

enum SocketAction { username, message, unknown }

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
  static const String namePrefix = "name:";
  static const String messagePrefix = "message:";
}