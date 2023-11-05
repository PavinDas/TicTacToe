import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class ScreenGame extends StatefulWidget {
  String player1;
  String player2;
  ScreenGame({required this.player1, required this.player2});
  @override
  State<ScreenGame> createState() => _ScreenGameState();
}

class _ScreenGameState extends State<ScreenGame> {
  late List<List<String>> _board;
  late String _currentPlyer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _board = List.generate(
      3,
      (index) => List.generate(3, (index) => ''),
    );
    _currentPlyer = 'X';
    _winner = '';
    _gameOver = false;
  }

  //* Rest Game
  _resetGame() {
    setState(
      () {
        super.initState();
        _board = List.generate(
          3,
          (index) => List.generate(3, (index) => ''),
        );
        _currentPlyer = 'X';
        _winner = '';
        _gameOver = false;
      },
    );
  }

  //* Make Move
  _makeMove(int row, int col) {
    if (_board[row][col] != '' || _gameOver) {
      return;
    }
    setState(
      () {
        _board[row][col] = _currentPlyer;

        //* Check for a Winner
        if (_board[row][0] == _currentPlyer &&
            _board[row][1] == _currentPlyer &&
            _board[row][2] == _currentPlyer) {
          _winner = _currentPlyer;
          _gameOver = true;
        } else if (_board[0][col] == _currentPlyer &&
            _board[1][col] == _currentPlyer &&
            _board[2][col] == _currentPlyer) {
          _winner = _currentPlyer;
          _gameOver = true;
        } else if (_board[0][0] == _currentPlyer &&
            _board[1][1] == _currentPlyer &&
            _board[2][2] == _currentPlyer) {
          _winner = _currentPlyer;
          _gameOver = true;
        } else if (_board[0][2] == _currentPlyer &&
            _board[1][1] == _currentPlyer &&
            _board[2][0] == _currentPlyer) {
          _winner = _currentPlyer;
          _gameOver = true;
        }

        //* Switch Players
        _currentPlyer = _currentPlyer == "X" ? "O" : "X";

        //* Check for a Tie
        if (!_board.any((row) => row.any((cell) => cell == ''))) {
          _gameOver = true;
          _winner = "It's a Tie";
        }

        if (_winner != '') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            btnOkText: 'Play Again',
            title: _winner == 'X'
                ? '${widget.player1}Win!'
                : _winner == 'O'
                    ? '${widget.player2}win!'
                    : "It's a Tie",
            btnOkOnPress: () {
              _resetGame();
            },
          ).show();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323D5B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 120,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Turn: ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _currentPlyer == "X"
                            ? '${widget.player1}  $_currentPlyer'
                            : '${widget.player2}  $_currentPlyer',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _currentPlyer == 'X'
                              ? const Color(0xFFE25041)
                              : const Color(0XFF1CBD9E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(5),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: _makeMove(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E1E3A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _board[row][col],
                          style: TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.bold,
                            color: _board[row][col] == "X"
                                ? const Color(0xFFE25041)
                                : const Color(0XFF1CBD9E),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
