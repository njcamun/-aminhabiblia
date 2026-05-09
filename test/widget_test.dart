import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aminhabiblia/main.dart';

void main() {
  testWidgets('App shell renders MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AMinhaBibliaApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
