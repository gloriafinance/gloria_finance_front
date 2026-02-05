import 'package:gloria_finance/app/locale_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group('LocaleStore', () {
    test('inicializa con pt_BR como locale padrão', () {
      final store = LocaleStore();

      expect(store.locale, const Locale('pt', 'BR'));
      expect(
        store.supportedLocales,
        containsAll(
          const [
            Locale('pt', 'BR'),
            Locale('es'),
            Locale('en'),
          ],
        ),
      );
    });
  });
}
