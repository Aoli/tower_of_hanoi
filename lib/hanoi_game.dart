import 'package:flutter/material.dart';
import 'package:tower_of_hanoi/tower_widget.dart';
import 'dart:math';
import 'main.dart';

class HanoiGame extends StatefulWidget {
  const HanoiGame({super.key});

  @override
  State<HanoiGame> createState() => _HanoiGameState();
}

class _HanoiGameState extends State<HanoiGame> {
  // Game State Variables
  int _numberOfDisks = 5;
  List<List<int>> _towers = [];
  int _currentPlayer = 1;
  int? _selectedTowerIndex;
  int _moveCount = 0;
  Map<String, dynamic>? _lastMove; // { 'disk': int, 'from': int, 'to': int }
  bool _gameWon = false;

  // Message Box State
  String _message = 'Player 1, select a tower to pick up a disk.';
  Color _messageBgColor = Colors.transparent;
  Color _messageTextColor = Colors.blueGrey.shade600;

  // Disk Colors - a vibrant palette for visual appeal
  final List<Color> _diskColors = const [
    Color(0xFFEF4444), // red-500
    Color(0xFFF97316), // orange-500
    Color(0xFFEAB308), // yellow-500
    Color(0xFF84CC16), // lime-500
    Color(0xFF22C55E), // green-500
    Color(0xFF14B8A6), // teal-500
    Color(0xFF3B82F6), // blue-500
    Color(0xFF8B5CF6), // violet-500
  ];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  /// Initializes or restarts the game.
  void _initGame() {
    setState(() {
      _gameWon = false;
      _towers = [[], [], []];
      // Create disks and add to the first tower
      for (int i = _numberOfDisks; i > 0; i--) {
        _towers[0].add(i);
      }
      _currentPlayer = 1;
      _selectedTowerIndex = null;
      _moveCount = 0;
      _lastMove = null;

      _updateMoveCount();
      _updatePlayerTurn();
      _displayMessage('Player 1, select a tower to pick up a disk.', 'info');
    });
  }

  /// Handles the logic when a player taps on a tower.
  /// [clickedTowerIndex] - The index (0, 1, or 2) of the tower that was tapped.
  void _handleTowerTap(int clickedTowerIndex) {
    if (_gameWon) return; // Stop interaction if the game is over

    // 1. Logic for selecting a source tower
    if (_selectedTowerIndex == null) {
      if (_towers[clickedTowerIndex].isNotEmpty) {
        setState(() {
          _selectedTowerIndex = clickedTowerIndex;
        });
        _displayMessage(
          'Player $_currentPlayer, now select a destination tower.',
          'info',
        );
      } else {
        _displayMessage('Cannot select an empty tower. Try again.', 'error');
      }
    }
    // 2. Logic for selecting a destination tower (making a move)
    else {
      // Disallow dropping disk on the same tower
      if (_selectedTowerIndex == clickedTowerIndex) {
        setState(() {
          _selectedTowerIndex = null;
        });
        _displayMessage(
          'Move cancelled. Player $_currentPlayer, select a source tower.',
          'info',
        );
        return;
      }

      final List<int> sourceTower = _towers[_selectedTowerIndex!];
      final List<int> destTower = _towers[clickedTowerIndex];
      final int diskToMove = sourceTower.last;

      // --- Validation Checks ---
      // Rule 1: Cannot place a larger disk on a smaller one.
      if (destTower.isNotEmpty && diskToMove > destTower.last) {
        _displayMessage(
          'Invalid Move: Cannot place a larger disk on a smaller one.',
          'error',
        );
        setState(() {
          _selectedTowerIndex = null; // Reset selection
        });
        return;
      }

      // Rule 2 (Competitive): Cannot immediately reverse the opponent's last move.
      if (_lastMove != null &&
          _lastMove!['disk'] == diskToMove &&
          _lastMove!['from'] == clickedTowerIndex &&
          _lastMove!['to'] == _selectedTowerIndex) {
        _displayMessage(
          "Invalid Move: Cannot immediately reverse the opponent's last move.",
          'error',
        );
        setState(() {
          _selectedTowerIndex = null;
        });
        return;
      }

      // --- If move is valid, execute it ---
      setState(() {
        final int movedDisk = sourceTower.removeLast();
        destTower.add(movedDisk);

        // Update game state
        _moveCount++;
        _lastMove = {
          'disk': movedDisk,
          'from': _selectedTowerIndex,
          'to': clickedTowerIndex,
        };

        _updateMoveCount();

        // Check for win condition
        if (_checkWin()) {
          _gameWon = true;
          _displayMessage(
            'Congratulations! Player $_currentPlayer wins in $_moveCount moves!',
            'success',
          );
          _updatePlayerTurn(isWinner: true);
        } else {
          // Switch to the next player
          _switchPlayer();
          _displayMessage(
            'Player $_currentPlayer, select a tower to pick up a disk.',
            'info',
          );
        }

        _selectedTowerIndex = null; // Reset selection after move
      });
    }
  }

  /// Checks if the win condition has been met (all disks on the last tower).
  /// Returns true if a player has won, false otherwise.
  bool _checkWin() {
    // Win condition is when the last tower has all the disks.
    return _towers[2].length == _numberOfDisks;
  }

  /// Switches the current player.
  void _switchPlayer() {
    _currentPlayer = _currentPlayer == 1 ? 2 : 1;
    _updatePlayerTurn();
  }

  /// Updates the UI to show the current player's turn.
  /// [isWinner] - If true, displays a winner message instead of turn info.
  void _updatePlayerTurn({bool isWinner = false}) {
    setState(() {
      if (isWinner) {
        _message = 'Player $_currentPlayer Wins!';
        _messageBgColor = Colors.green.shade200;
        _messageTextColor = Colors.green.shade800;
      } else if (_currentPlayer == 1) {
        _message = "Player 1's Turn";
        _messageBgColor = Colors.blue.shade200;
        _messageTextColor = Colors.blue.shade800;
      } else {
        _message = "Player 2's Turn";
        _messageBgColor = Colors.red.shade200;
        _messageTextColor = Colors.red.shade800;
      }
    });
  }

  /// Displays a message to the user (e.g., instructions, errors, success).
  /// [text] - The message to display.
  /// [type] - 'info', 'error', or 'success' for styling.
  void _displayMessage(String text, String type) {
    setState(() {
      _message = text;
      switch (type) {
        case 'error':
          _messageBgColor = Colors.red.shade100;
          _messageTextColor = Colors.red.shade600;
          break;
        case 'success':
          _messageBgColor = Colors.green.shade100;
          _messageTextColor = Colors.green.shade600;
          break;
        case 'info':
        default:
          _messageBgColor = Colors.transparent;
          _messageTextColor = Colors.blueGrey.shade600;
          break;
      }
    });
  }

  /// Updates the move count on the UI.
  void _updateMoveCount() {
    setState(() {
      _moveCount; // Simply trigger a rebuild to show updated count
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50, // bg-slate-100
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 800), // max-w-4xl
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // shadow-lg
                ),
              ],
            ),
            padding: const EdgeInsets.all(24.0), // p-6 md:p-8
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ), // border-b
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Two-Player Tower of Hanoi',
                        style: TextStyle(
                          fontSize: 32.0, // text-3xl md:text-4xl
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade900, // text-slate-900
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'A competitive game of logic and strategy.',
                        style: TextStyle(
                          color: Colors.blueGrey.shade500, // text-slate-500
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Game Info Bar
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50, // bg-slate-50
                    borderRadius: BorderRadius.circular(8.0), // rounded-lg
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _message,
                          style: TextStyle(
                            fontSize: 18.0, // text-xl
                            fontWeight: FontWeight.w600,
                            color: _messageTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Moves: ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                          Text(
                            '$_moveCount',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            'Optimal: ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                          Text(
                            '${pow(2, _numberOfDisks).toInt() - 1}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Message Area - This is now handled by the info bar for simplicity
                // If a separate message box is desired, it would go here.

                // Game Board
                Container(
                  height: 250, // min-h-[250px]
                  margin: const EdgeInsets.only(bottom: 32.0), // mb-8
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(3, (towerIndex) {
                      return GestureDetector(
                        onTap: () => _handleTowerTap(towerIndex),
                        child: TowerWidget(
                          disks: _towers[towerIndex],
                          numberOfDisks: _numberOfDisks,
                          isSelected: _selectedTowerIndex == towerIndex,
                          diskColors: _diskColors,
                        ),
                      );
                    }),
                  ),
                ),

                // Controls
                Container(
                  padding: const EdgeInsets.only(top: 24.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ), // border-t
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Disks:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      DropdownButton<int>(
                        value: _numberOfDisks,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _numberOfDisks = newValue;
                            });
                            _initGame();
                          }
                        },
                        items: <int>[3, 4, 5, 6, 7].map<DropdownMenuItem<int>>((
                          int value,
                        ) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: _initGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600, // bg-blue-600
                          foregroundColor: Colors.white, // text-white
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 12.0,
                          ), // py-2 px-6
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // rounded-lg
                          ),
                          shadowColor: Colors.blue.shade700.withOpacity(0.3),
                          elevation: 3, // shadow-sm
                        ),
                        child: const Text(
                          'Restart Game',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
