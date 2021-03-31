
import 'package:charisma/common/charisma_textformfield_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('it should have one TextFormField', (WidgetTester tester) async {
    await tester.pumpWidget(CharismaTextFormField(
      key: ValueKey('key'),
      fieldName: 'fieldName',
    ).wrapWithMaterial());

    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('it should not have InfoText Text when infoText is not provided', (WidgetTester tester) async {
    await tester.pumpWidget(CharismaTextFormField(
        key: ValueKey('key'),
        fieldName: 'fieldName'
    ).wrapWithMaterial());

    expect(find.byKey(ValueKey('InfoTextKey')), findsNothing);
  });

  testWidgets('it should have InfoText Text when infoText is provided', (WidgetTester tester) async {
    await tester.pumpWidget(CharismaTextFormField(
      key: ValueKey('key'),
      fieldName: 'fieldName',
      infoText: 'InfoText',
    ).wrapWithMaterial());

    expect(find.byKey(ValueKey('InfoTextKey')), findsOneWidget);
  });
}

extension on Widget {
  Widget wrapWithMaterial() => MaterialApp(
      home: Scaffold(
        body: this,
      )
  );
}