import 'package:family_competition/pages/game_page.dart';
import 'package:family_competition/services/server.dart';
import 'package:family_competition/services/socket_service.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
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
      showInfoDialog(context, errorMessage, () {}, false);
    });
  }

  void _startServer() {
    _setGameInfo();
    connectAsServer().then((server) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage())).then((_) {
        showInfoDialog(context, "You are about to end server!", () async {
          LoadingOverlay.show(context);
          await server.close().then((_)  {
            LoadingOverlay.hide();
          });
        }, false);
      });
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
        child: Container(
          width: 385,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), // Set the corner radius here
            gradient: metallicGradient,
          ),
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
                    prefixIcon: const Icon(Icons.person, color: metallicLightColor,)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                child: appTextField(
                    controller: portController,
                    width: 140,
                    maxLength: 4,
                    labelText: "Port",
                    hintText: "3000",
                    prefixIcon: const Icon(Icons.settings_input_antenna, color: metallicLightColor,)),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Connect As',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: metallicLightColor),
                    ),
                    AppButton(title: "Client", icon: Icons.settings_input_antenna, onPressed: _startClient),
                    AppButton(title: "Server", icon: Icons.computer_sharp, onPressed: _startServer),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}