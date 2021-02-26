// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:charisma/apiclient/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:charisma/main.dart';
import 'package:mockito/mockito.dart';

void main() {
  testWidgets('It displays Hello World text', (WidgetTester tester) async {

    final apiClient = MockApiClient();
    await tester.pumpWidget(CharismaApp(apiClient));

    expect(find.text('Hello World. This is Charisma.'), findsOneWidget);

  });
}

class MockApiClient extends Mock implements ApiClient{}
