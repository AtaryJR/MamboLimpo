import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mambolimpo/main.dart';

void main() {
  testWidgets('App carrega o smoke test', (WidgetTester tester) async {
    // Carrega nosso app Mambo Limpo dentro do ProviderScope
    await tester.pumpWidget(const ProviderScope(child: MamboLimpoApp()));
  });
}
