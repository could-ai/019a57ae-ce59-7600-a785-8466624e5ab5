import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:couldai_user_app/main.dart';

void main() {
  testWidgets('2048 game smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Game2048App());

    // Verify that the game title is displayed.
    expect(find.text('2048'), findsOneWidget);

    // Verify that score labels are displayed.
    expect(find.text('SCORE'), findsOneWidget);
    expect(find.text('BEST'), findsOneWidget);

    // Verify that the New Game button is displayed.
    expect(find.text('New Game'), findsOneWidget);

    // Verify that instructions are displayed.
    expect(find.text('Join the tiles, get to 2048!'), findsOneWidget);
  });
}
