import 'package:flutter/material.dart';
import '../models/tile.dart';
import 'tile_widget.dart';

class GameBoard extends StatelessWidget {
  final List<List<Tile?>> grid;
  final int gridSize;

  const GameBoard({
    super.key,
    required this.grid,
    required this.gridSize,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 8.0;
          final boardSize = constraints.maxWidth;
          final tileSize = (boardSize - (gridSize + 1) * spacing) / gridSize;
          
          return Container(
            padding: const EdgeInsets.all(spacing),
            decoration: BoxDecoration(
              color: const Color(0xFFBBADA0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Background grid cells
                for (int row = 0; row < gridSize; row++)
                  for (int col = 0; col < gridSize; col++)
                    Positioned(
                      left: col * (tileSize + spacing),
                      top: row * (tileSize + spacing),
                      width: tileSize,
                      height: tileSize,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFCDC1B4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                // Tile widgets
                for (int row = 0; row < gridSize; row++)
                  for (int col = 0; col < gridSize; col++)
                    if (grid[row][col] != null)
                      TileWidget(
                        key: ValueKey('${grid[row][col]!.row}_${grid[row][col]!.col}_${grid[row][col]!.value}'),
                        tile: grid[row][col]!,
                        tileSize: tileSize,
                        spacing: spacing,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
