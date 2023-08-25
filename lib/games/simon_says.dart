import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class SimonSaysGame extends StatefulWidget {
  @override
  _SimonSaysGameState createState() => _SimonSaysGameState();
}

class _SimonSaysGameState extends State<SimonSaysGame> {
  List<int> sequence = [];
  List<int> playerSequence = [];
  int currentStep = 0;
  int successNum = 1;
  bool isGameActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simon Says Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Simon Says $successNum', style: const TextStyle(fontSize: 30)),

            SizedBox(height: 20),
            Wrap(
              children: List.generate(4, (index) {
                return GestureDetector(
                  onTap: isGameActive ? () => playerTurn(index) : null,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: getColor(index),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: isGameActive ? null : startGame,
        backgroundColor: !isGameActive ? Colors.green : Colors.grey,
        child: const Icon(Icons.lock_reset),
      ),
    );
  }

  void startGame() {
    setState(() {
      sequence.clear();
      playerSequence.clear();
      currentStep = 0;
      successNum = 1;
      isGameActive = true;
      addRandomStep();
      playSequence();
    });
  }

  void addRandomStep() {
    Random random = Random();
    int nextStep = random.nextInt(4);
    sequence.add(nextStep);
  }

  void playSequence() async {
    for (int step in sequence) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        currentStep = step;
      });
      SystemSound.play(SystemSoundType.click);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        currentStep = -1; // Reset to no step
      });
    }
  }

  void playerTurn(int index) {
    if (isGameActive) {
      setState(() {
        SystemSound.play(SystemSoundType.click);
        playerSequence.add(index);
        if (!checkPlayerSequence()) {
          endGame();
        } else if (playerSequence.length == sequence.length) {
          addRandomStep();
          playerSequence.clear();
          successNum++;
          playSequence();
        }
      });
    }
  }

  bool checkPlayerSequence() {
    for (int i = 0; i < playerSequence.length; i++) {
      if (playerSequence[i] != sequence[i]) {
        return false;
      }
    }
    return true;
  }

  Color getColor(int index) {
    if (currentStep == index) {
      return Colors.grey;
    } else {
      return Colors.primaries[index];
    }
  }

  void endGame() {
    setState(() {
      isGameActive = false;
      playerSequence.clear();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('You lost. Would you like to play again?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startGame();
                },
                child: Text('Play Again'),
              ),
            ],
          );
        },
      );
    });
  }
}
