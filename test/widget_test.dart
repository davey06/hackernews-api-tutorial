import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:news_sqlite/main.dart';
import 'package:news_sqlite/resource/news_api_provider.dart';

void main() {
  test("Fetch Top Stories Test", () async {
    final newsAPI = NewsApiProvider();
//    newsAPI.client = MockClient((req) async {
//      return Response(json.encode([1, 2, 3, 4]), 200);
//    });

    final ids = await newsAPI.fetchTopIds();
    final item = await newsAPI.fetchItem(23705495);
    print(ids);
    print(item);
  });
//  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(MyApp());
//
//    // Verify that our counter starts at 0.
//    expect(find.text('0'), findsOneWidget);
//    expect(find.text('1'), findsNothing);
//
//    // Tap the '+' icon and trigger a frame.
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();
//
//    // Verify that our counter has incremented.
//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
//  });
}
