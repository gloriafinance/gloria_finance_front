import 'package:church_finance_bk/app/locale_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

