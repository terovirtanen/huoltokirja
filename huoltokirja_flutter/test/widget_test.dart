import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja_flutter/features/dependants/presentation/dependant_editor_dialog.dart';
import 'package:huoltokirja_flutter/shared/widgets/app_menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('dependant editor requires name before save', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DependantEditorDialog())),
    );

    await tester.tap(find.text('Tallenna'));
    await tester.pumpAndSettle();

    expect(find.text('Nimi on pakollinen'), findsOneWidget);
  });

  testWidgets('menu button opens drawer-style side menu', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            drawer: const AppMenuDrawer(),
            appBar: AppBar(leading: const AppMenuButton()),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsOneWidget);
    expect(find.text('Vie tiedot CSV-tiedostoon'), findsOneWidget);
    expect(find.text('Tulosta PDF-raportti'), findsOneWidget);
    expect(find.text('Vaihda kieli'), findsOneWidget);
    expect(find.textContaining('Nykyinen:'), findsWidgets);
  });
}
