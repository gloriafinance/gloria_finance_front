import 'package:gloria_finance/app/locale_store.dart';
import 'package:gloria_finance/core/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguageSelector', () {
    testWidgets('muestra el locale actual y permite cambiarlo', (tester) async {
      SharedPreferences.setMockInitialValues(const {});
      final store = LocaleStore();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: store,
          child: const MaterialApp(
            home: Scaffold(
              body: Center(child: LanguageSelector()),
            ),
          ),
        ),
      );

      // Por defecto debe mostrar el locale pt-BR
      expect(find.text('PT-BR'), findsOneWidget);

      // Abre el menú y selecciona EN
      await tester.tap(find.byType(PopupMenuButton<Locale>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('EN').last);
      await tester.pumpAndSettle();

      expect(store.locale, const Locale('en'));
      expect(find.text('EN'), findsOneWidget);
    });
  });
}
