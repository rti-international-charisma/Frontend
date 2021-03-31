
import 'package:charisma/common/charisma_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main () {
  var items =  <CharismaDropDownItem>[
    CharismaDropDownItem('1', 'Question1'),
    CharismaDropDownItem('2', 'Question2'),
  ];

  testWidgets('it should have a dropdown', (WidgetTester tester ) async {
    await tester.pumpWidget(CharismaDropdown(
        key: ValueKey('ddkey'),
        fieldName: 'fieldName',
        items: items,
        onChanged: (CharismaDropDownItem? item) {}
    ).wrapWithMaterial());

    expect(find.byKey(ValueKey('CharismaDDButtonKey')), findsOneWidget);
  });

  testWidgets('it should display selected value', (WidgetTester tester ) async {
    await tester.pumpWidget(CharismaDropdown(
        key: ValueKey('ddkey'),
        fieldName: 'fieldName',
        items:  <CharismaDropDownItem>[
          CharismaDropDownItem('1', 'Question1')
        ],
        onChanged: (CharismaDropDownItem? item) {}
    ).wrapWithMaterial());

    await tester.tap(find.byKey(ValueKey('CharismaDDButtonKey')));
    await tester.pump();

    expect(find.text('Question1'), findsWidgets);
  });

  testWidgets('it should display FieldName', (WidgetTester tester ) async {
    await tester.pumpWidget(CharismaDropdown(
        key: ValueKey('ddkey'),
        fieldName: 'fieldName',
        items:  <CharismaDropDownItem>[
          CharismaDropDownItem('1', 'Question1')
        ],
        onChanged: (CharismaDropDownItem? item) {}
    ).wrapWithMaterial());

    expect(find.text('fieldName'), findsOneWidget);
  });

  testWidgets('it should not display Infotext when Infotext is absent', (WidgetTester tester ) async {
    await tester.pumpWidget(CharismaDropdown(
        key: ValueKey('ddkey'),
        fieldName: 'fieldName',
        items:  <CharismaDropDownItem>[
          CharismaDropDownItem('1', 'Question1')
        ],
        onChanged: (CharismaDropDownItem? item) {}
    ).wrapWithMaterial());

    expect(find.byKey(ValueKey('DDInfoTextKey')), findsNothing);
  });

  testWidgets('it should  display Infotext when Infotext is present', (WidgetTester tester ) async {
    await tester.pumpWidget(CharismaDropdown(
        key: ValueKey('ddkey'),
        fieldName: 'fieldName',
        infoText: 'Infotext',
        items:  <CharismaDropDownItem>[
          CharismaDropDownItem('1', 'Question1')
        ],
        onChanged: (CharismaDropDownItem? item) {}
    ).wrapWithMaterial());

    expect(find.text('Infotext'), findsOneWidget);
  });


}

extension on Widget {
  Widget wrapWithMaterial() => MaterialApp(
      home: Scaffold(
        body: this,
      )
  );
}

class Caller {
  void mockOnComplete(CharismaDropDownItem? item){}
}
class MockCaller extends Mock implements Caller{
}