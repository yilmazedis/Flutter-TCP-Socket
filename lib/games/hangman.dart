import 'dart:math';

import 'package:flutter/material.dart';

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key});

  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final List<String> words = ['FLUTTER', 'HANGMAN', 'GUESS', 'GAME', 'DEVELOPER'];
  String selectedWord = '';
  List<String> guessedLetters = [];
  int attemptsLeft = 6;
  bool _gameOver = false;
  String _matchResult = "";
  final String _hiddenLetter = "_";

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final random = Random();
    selectedWord = words[random.nextInt(words.length)];
    guessedLetters.clear();
    attemptsLeft = 6;
    _gameOver = false;
  }

  void _guessLetter(String letter) {
    setState(() {
      guessedLetters.add(letter);
      if (!selectedWord.contains(letter)) {
        attemptsLeft--;
      }
      if (attemptsLeft == 0) {
        _matchResult = "Game Over";
        _gameOver = true;
      }

      if (!_getDisplayWord().contains(_hiddenLetter)) {
        _matchResult = "You Win";
        _gameOver = true;
      }
    });
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Attempts Left: $attemptsLeft',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              _getDisplayWord(),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, // You can adjust the number of columns here
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: 26,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final letter = String.fromCharCode('A'.codeUnitAt(0) + index);
                  return GestureDetector(
                    onTap: () {
                      if (!guessedLetters.contains(letter)) {
                        _guessLetter(letter);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: guessedLetters.contains(letter)
                            ? Colors.grey
                            : Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_gameOver)
              Text(
                _matchResult,
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: _gameOver ? _resetGame : null,
        backgroundColor: _gameOver ? Colors.green : Colors.grey,
        child: const Icon(Icons.lock_reset),
      ),
    );
  }

  String _getDisplayWord() {
    return selectedWord.split('').map((letter) {
      return guessedLetters.contains(letter) ? letter : _hiddenLetter;
    }).join(' ');
  }
}
