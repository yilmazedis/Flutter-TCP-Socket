import 'dart:io';

enum SocketAction { login, successMessage, unknown }

SocketAction parseStringToSocketAction(String value) {
  switch (value) {
    case "SocketAction.login":
      return SocketAction.login;
    case "SocketAction.successMessage":
      return SocketAction.successMessage;
    default:
      return SocketAction.unknown;
  }
}

typedef SocketCommand = MapEntry<SocketAction, Object>;
typedef LoginCommand = MapEntry<SocketAction, String>;

void sendMessageToServer(Socket socket, SocketCommand message) {
  // print("Client: ${message.key} - ${message.value}");
  socket.write(message);
}

SocketCommand parseCommand(String message) {
  List<String> splitMessage =
  message.substring(9, message.indexOf(")")).split(":");

  return SocketCommand(
    parseStringToSocketAction(splitMessage.removeAt(0)),
    splitMessage.join(),
  );
}
