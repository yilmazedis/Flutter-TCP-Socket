import 'dart:io';

import 'package:flutter/cupertino.dart';

class Game {
  late String name;
  late int userLimit;
  late Widget Function(Socket) gameFactory;

  Game({required this.name, required this.userLimit, required this.gameFactory});

  Widget createGameWidget({required Socket socket}) {
    return gameFactory(socket);
  }
}
