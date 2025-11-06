import 'package:flutter/material.dart';
import '../models/tile.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;
  final double tileSize;

  const TileWidget({
    super.key,
    required this.tile,
    required this.tileSize,
  });

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return const Color(0xFFEEE4DA);
      case 4:
        return const Color(0xFFEDE0C8);
      case 8:
        return const Color(0xFFF2B179);
      case 16:
        return const Color(0xFFF59563);
      case 32:
        return const Color(0xFFF67C5F);
      case 64:
        return const Color(0xFFF65E3B);
      case 128:
        return const Color(0xFFEDCF72);
      case 256:
        return const Color(0xFFEDCC61);
      case 512:
        return const Color(0xFFEDC850);
      case 1024:
        return const Color(0xFFEDC53F);
      case 2048:
        return const Color(0xFFEDC22E);
      default:
        return const Color(0xFF3C3A32);
    }
  }

  Color _getTextColor(int value) {
    return value <= 4 ? const Color(0xFF776E65) : Colors.white;
  }

  double _getFontSize(int value) {
    if (value < 100) return 32;
    if (value < 1000) return 28;
    if (value < 10000) return 24;
    return 20;
  }

  @override
  Widget build(BuildContext context) {
    final left = tile.col * (tileSize + 8) + 8;
    final top = tile.row * (tileSize + 8) + 8;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      left: left,
      top: top,
      width: tileSize,
      height: tileSize,
      child: Container(
        decoration: BoxDecoration(
          color: _getTileColor(tile.value),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            '${tile.value}',
            style: TextStyle(
              fontSize: _getFontSize(tile.value),
              fontWeight: FontWeight.bold,
              color: _getTextColor(tile.value),
            ),
          ),
        ),
      ),
    );
  }
}