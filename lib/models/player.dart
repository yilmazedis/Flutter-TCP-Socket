import 'dart:io';

class Player {
  late Socket socket;
  late String username;
  late String message;

  Player({required this.socket, required this.username, required this.message});
}
