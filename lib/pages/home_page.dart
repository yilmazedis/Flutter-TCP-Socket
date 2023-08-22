import 'package:family_competition/pages/game_page.dart';
import 'package:family_competition/services/client.dart';
import 'package:family_competition/services/server.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _startClient() {
    navigateToGamePage(context);
  }

  void _startServer() {
    connectAsServer().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage()));
    });
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
          children: <Widget>[
            const Text(
              'Connect As',
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: UniqueKey(),
                    onPressed: _startClient,
                    child: const Column(
                      children: [
                        Text("Client"),
                        Icon(Icons.person),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: UniqueKey(),
                    onPressed: _startServer,
                    child: const Column(
                      children: [
                        Text("Server"),
                        Icon(Icons.group),
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