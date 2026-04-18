import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biblia_app/main.dart';

void main() {
  testWidgets('App shell renders MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BibliaApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
