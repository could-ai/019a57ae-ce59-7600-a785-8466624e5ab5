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
                // Background grid - use Positioned.fill to avoid parent data issues
                Positioned.fill(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFCDC1B4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ),
                // Tiles layer - each TileWidget returns AnimatedPositioned directly
                ...() {
                  final List<Widget> tiles = [];
                  for (int row = 0; row < gridSize; row++) {
                    for (int col = 0; col < gridSize; col++) {
                      final tile = grid[row][col];
                      if (tile != null) {
                        tiles.add(
                          TileWidget(
                            key: ValueKey('${tile.row}_${tile.col}_${tile.value}'),
                            tile: tile,
                            tileSize: tileSize,
                            spacing: spacing,
                          ),
                        );
                      }
                    }
                  }
                  return tiles;
                }(),
              ],
            ),
          );
        },
      ),
    );
  }
}
