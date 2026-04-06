import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja_flutter/features/dependants/presentation/dependant_editor_dialog.dart';

void main() {
  testWidgets('dependant editor requires name before save', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DependantEditorDialog()),
      ),
    );

    await tester.tap(find.text('Tallenna'));
    await tester.pumpAndSettle();

    expect(find.text('Nimi on pakollinen'), findsOneWidget);
  });
}
