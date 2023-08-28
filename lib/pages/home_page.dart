import 'package:family_competition/pages/game_page.dart';
import 'package:family_competition/services/server.dart';
import 'package:family_competition/services/socket_service.dart';
import 'package:flutter/material.dart';

import '../utils/app_text_field.dart';
import '../utils/game_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController nameController = TextEditingController(text: playerName);
  TextEditingController portController = TextEditingController(text: portNumber.toString());

  void _startClient() {
    _setGameInfo();
    navigateToGamePage(context, (errorMessage) {
      showErrorDialog(context, errorMessage, () {});
    });
  }

  void _startServer() {
    _setGameInfo();
    connectAsServer().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage()));
    });
  }

  void _setGameInfo() {
    playerName = nameController.text;
    portNumber = int.tryParse(portController.text) ?? portNumber;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
              child: appTextField(
                  controller: nameController,
                  maxLength: 40,
                  labelText: "Name",
                  hintText: "Yılmaz",
                  prefixIcon: const Icon(Icons.person)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
              child: appTextField(
                  controller: portController,
                  width: 140,
                  maxLength: 4,
                  labelText: "Port",
                  hintText: "3000",
                  prefixIcon: const Icon(Icons.settings_input_antenna)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Connect As',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton(
                    heroTag: UniqueKey(),
                    onPressed: _startClient,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Client"),
                        Icon(Icons.settings_input_antenna),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton(
                    heroTag: UniqueKey(),
                    onPressed: _startServer,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Server"),
                        Icon(Icons.computer),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}