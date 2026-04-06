import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja_flutter/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts and shows root screen', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Huoltokirja'), findsOneWidget);
  });
}
