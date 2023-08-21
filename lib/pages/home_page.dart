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
  int _counter = 0;

  void _startClient() {
    connectAsClient();
  }

  void _startServer() {
    connectAsServer().then((value) {
      connectAsClient();
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: _startClient,
                    tooltip: 'Client',
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
                    onPressed: _startServer,
                    tooltip: 'Server',
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
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
