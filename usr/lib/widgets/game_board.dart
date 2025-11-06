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
          final boardSize = constraints.maxWidth;
          final tileSize = (boardSize - (gridSize + 1) * 8) / gridSize;
          
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFBBADA0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Background grid
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
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
                // Tiles - each TileWidget returns AnimatedPositioned directly
                ...List.generate(gridSize, (row) {
                  return List.generate(gridSize, (col) {
                    final tile = grid[row][col];
                    if (tile != null) {
                      return TileWidget(
                        tile: tile,
                        tileSize: tileSize,
                      );
                    }
                    return const SizedBox.shrink();
                  });
                }).expand((element) => element),
              ],
            ),
          );
        },
      ),
    );
  }
}
