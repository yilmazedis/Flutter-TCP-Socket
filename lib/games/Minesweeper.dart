import 'package:family_competition/utils/terminal_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MinesweeperGame extends StatefulWidget {
  const MinesweeperGame({super.key});

  @override
  _MinesweeperGameState createState() => _MinesweeperGameState();
}

class _MinesweeperGameState extends State<MinesweeperGame> {
  final int rows = 8;
  final int columns = 8;
  final int totalMines = 10;
  late List<List<bool>> revealed;
  late List<List<bool>> isMine;
  String _matchResult = "";
  bool _gameOver = false;

  int totalNonMines = 0;
  int revealedNonMines = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _resetGame() {
    setState(() {
      _initGame();
    });
  }

  void _initGame() {
    revealed = List.generate(rows, (r) => List.filled(columns, false));
    isMine = List.generate(rows, (r) => List.filled(columns, false));
    placeMines();
    _gameOver = false;

    // Calculate the total number of non-mine cells
    totalNonMines = rows * columns - totalMines;
  }

  void placeMines() {
    final random = Random();
    int count = 0;

    while (count < totalMines) {
      int row = random.nextInt(rows);
      int col = random.nextInt(columns);

      if (!isMine[row][col]) {
        isMine[row][col] = true;
        count++;
      }
    }
  }

  void reveal(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= columns || revealed[row][col]) {
      return;
    }

    revealed[row][col] = true;

    if (isMine[row][col]) {
      // Handle game over
      printDebug("Game Over");
      _matchResult = "Game Over";
      _gameOver = true;
    } else {
      int mineCount = countAdjacentMines(row, col);
      if (mineCount == 0) {
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            reveal(row + i, col + j);
          }
        }
      }
    }

    if (!isMine[row][col]) {
      revealedNonMines++;
      if (revealedNonMines == totalNonMines) {
        // Player has won the game
        _matchResult = "You Win!";
        _gameOver = true;
      }
    }
  }

  int countAdjacentMines(int row, int col) {
    int count = 0;

    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = row + i;
        int newCol = col + j;

        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < columns) {
          if (isMine[newRow][newCol]) {
            count++;
          }
        }
      }
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                ),
                itemCount: rows * columns,
                itemBuilder: (context, index) {
                  int row = index ~/ columns;
                  int col = index % columns;
                  int mineCount = countAdjacentMines(row, col);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        reveal(row, col);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: revealed[row][col] ? Colors.grey[300] : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          revealed[row][col] ? (isMine[row][col] ? "💣" : (mineCount == 0 ? "" : mineCount.toString())) : "",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_gameOver)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 50),
                  child: Text(
                    _matchResult, // Display your game result here
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
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
}
