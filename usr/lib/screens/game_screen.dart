import 'package:flutter/material.dart';
import 'dart:math';
import '../models/tile.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  static const int gridSize = 4;
  List<List<Tile?>> grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
  int score = 0;
  int bestScore = 0;
  bool gameOver = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _initGame();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initGame() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    score = 0;
    gameOver = false;
    _addRandomTile();
    _addRandomTile();
    setState(() {});
  }

  void _addRandomTile() {
    List<Point<int>> emptyCells = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == null) {
          emptyCells.add(Point(i, j));
        }
      }
    }

    if (emptyCells.isEmpty) return;

    final random = Random();
    final cell = emptyCells[random.nextInt(emptyCells.length)];
    final value = random.nextDouble() < 0.9 ? 2 : 4;
    grid[cell.x][cell.y] = Tile(value: value, row: cell.x, col: cell.y);
  }

  bool _canMove() {
    // Check for empty cells
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == null) return true;
      }
    }

    // Check for possible merges
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        final current = grid[i][j];
        if (current != null) {
          // Check right
          if (j < gridSize - 1 && grid[i][j + 1]?.value == current.value) return true;
          // Check down
          if (i < gridSize - 1 && grid[i + 1][j]?.value == current.value) return true;
        }
      }
    }

    return false;
  }

  void _move(Direction direction) {
    if (gameOver) return;

    bool moved = false;
    List<List<Tile?>> newGrid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    List<List<bool>> merged = List.generate(gridSize, (_) => List.filled(gridSize, false));

    void moveTile(int row, int col, int newRow, int newCol) {
      if (grid[row][col] != null) {
        if (newGrid[newRow][newCol] == null) {
          newGrid[newRow][newCol] = Tile(
            value: grid[row][col]!.value,
            row: newRow,
            col: newCol,
          );
          moved = true;
        } else if (newGrid[newRow][newCol]!.value == grid[row][col]!.value && !merged[newRow][newCol]) {
          newGrid[newRow][newCol] = Tile(
            value: grid[row][col]!.value * 2,
            row: newRow,
            col: newCol,
          );
          score += grid[row][col]!.value * 2;
          merged[newRow][newCol] = true;
          moved = true;
        }
      }
    }

    if (direction == Direction.left) {
      for (int i = 0; i < gridSize; i++) {
        int targetCol = 0;
        for (int j = 0; j < gridSize; j++) {
          if (grid[i][j] != null) {
            if (targetCol != j || (newGrid[i][targetCol] != null && newGrid[i][targetCol]!.value == grid[i][j]!.value)) {
              if (newGrid[i][targetCol] == null) {
                moveTile(i, j, i, targetCol);
              } else if (newGrid[i][targetCol]!.value == grid[i][j]!.value && !merged[i][targetCol]) {
                moveTile(i, j, i, targetCol);
                targetCol++;
              } else {
                targetCol++;
                moveTile(i, j, i, targetCol);
              }
            } else {
              newGrid[i][targetCol] = grid[i][j];
            }
            if (newGrid[i][targetCol] != null) targetCol++;
          }
        }
      }
    } else if (direction == Direction.right) {
      for (int i = 0; i < gridSize; i++) {
        int targetCol = gridSize - 1;
        for (int j = gridSize - 1; j >= 0; j--) {
          if (grid[i][j] != null) {
            if (targetCol != j || (newGrid[i][targetCol] != null && newGrid[i][targetCol]!.value == grid[i][j]!.value)) {
              if (newGrid[i][targetCol] == null) {
                moveTile(i, j, i, targetCol);
              } else if (newGrid[i][targetCol]!.value == grid[i][j]!.value && !merged[i][targetCol]) {
                moveTile(i, j, i, targetCol);
                targetCol--;
              } else {
                targetCol--;
                moveTile(i, j, i, targetCol);
              }
            } else {
              newGrid[i][targetCol] = grid[i][j];
            }
            if (newGrid[i][targetCol] != null) targetCol--;
          }
        }
      }
    } else if (direction == Direction.up) {
      for (int j = 0; j < gridSize; j++) {
        int targetRow = 0;
        for (int i = 0; i < gridSize; i++) {
          if (grid[i][j] != null) {
            if (targetRow != i || (newGrid[targetRow][j] != null && newGrid[targetRow][j]!.value == grid[i][j]!.value)) {
              if (newGrid[targetRow][j] == null) {
                moveTile(i, j, targetRow, j);
              } else if (newGrid[targetRow][j]!.value == grid[i][j]!.value && !merged[targetRow][j]) {
                moveTile(i, j, targetRow, j);
                targetRow++;
              } else {
                targetRow++;
                moveTile(i, j, targetRow, j);
              }
            } else {
              newGrid[targetRow][j] = grid[i][j];
            }
            if (newGrid[targetRow][j] != null) targetRow++;
          }
        }
      }
    } else if (direction == Direction.down) {
      for (int j = 0; j < gridSize; j++) {
        int targetRow = gridSize - 1;
        for (int i = gridSize - 1; i >= 0; i--) {
          if (grid[i][j] != null) {
            if (targetRow != i || (newGrid[targetRow][j] != null && newGrid[targetRow][j]!.value == grid[i][j]!.value)) {
              if (newGrid[targetRow][j] == null) {
                moveTile(i, j, targetRow, j);
              } else if (newGrid[targetRow][j]!.value == grid[i][j]!.value && !merged[targetRow][j]) {
                moveTile(i, j, targetRow, j);
                targetRow--;
              } else {
                targetRow--;
                moveTile(i, j, targetRow, j);
              }
            } else {
              newGrid[targetRow][j] = grid[i][j];
            }
            if (newGrid[targetRow][j] != null) targetRow--;
          }
        }
      }
    }

    if (moved) {
      grid = newGrid;
      _addRandomTile();
      
      if (score > bestScore) {
        bestScore = score;
      }

      if (!_canMove()) {
        gameOver = true;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header with title and scores
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2048',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF776E65),
                        ),
                      ),
                      Row(
                        children: [
                          _buildScoreBox('SCORE', score),
                          const SizedBox(width: 8),
                          _buildScoreBox('BEST', bestScore),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Instructions and New Game button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Join the tiles, get to 2048!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF776E65),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _initGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8F7A66),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'New Game',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Game board
                  GestureDetector(
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        _move(Direction.up);
                      } else if (details.primaryVelocity! > 0) {
                        _move(Direction.down);
                      }
                    },
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        _move(Direction.left);
                      } else if (details.primaryVelocity! > 0) {
                        _move(Direction.right);
                      }
                    },
                    child: GameBoard(grid: grid, gridSize: gridSize),
                  ),

                  if (gameOver)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDC22E).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Game Over! No more moves available.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  const Text(
                    'Use swipe gestures to move tiles',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF776E65),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBox(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFBBADA0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEEE4DA),
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

enum Direction { up, down, left, right }
