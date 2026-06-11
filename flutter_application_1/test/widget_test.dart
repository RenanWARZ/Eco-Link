import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App shows the login screen when no session is stored', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const EcoLinkApp());
    await tester.pump();
    await tester.pump();

    expect(find.text('EcoLink'), findsWidgets);
    expect(find.text('Entrar'), findsWidgets);
  });
}
