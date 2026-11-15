import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/core/layout/erp/menu_items.dart';

/// Regra de negócio: **Pagamentos recorrentes é um módulo exclusivo do Brasil**.
///
/// O item do menu só aparece para igrejas brasileiras; o acesso por URL direta é
/// bloqueado pelo guard das rotas em `features/erp/router.dart`.
void main() {
  const recurringKey = 'erp_menu_finance_recurring_payments';

  List<String> visibleKeys(List<Map<String, dynamic>> menu) {
    return [
      for (final section in menu)
        for (final item in section['items'] as List)
          (item as Map)['key'] as String,
    ];
  }

  group('menuItems · módulo exclusivo do Brasil', () {
    test('ADMIN no Brasil vê Pagamentos recorrentes', () {
      final keys = visibleKeys(menuItems(['ADMIN'], 'BR'));

      expect(keys, contains(recurringKey));
    });

    test('ADMIN fora do Brasil não vê Pagamentos recorrentes', () {
      for (final country in ['VE', 'US', 'BO', 'PT']) {
        final keys = visibleKeys(menuItems(['ADMIN'], country));

        expect(keys, isNot(contains(recurringKey)), reason: 'país $country');
      }
    });

    test('o país é comparado sem depender de maiúsculas', () {
      expect(visibleKeys(menuItems(['ADMIN'], 'br')), contains(recurringKey));
    });

    test('esconder o módulo não remove os outros itens de Finanças', () {
      final keys = visibleKeys(menuItems(['ADMIN'], 'VE'));

      expect(keys, contains('erp_menu_finance_accounts_payable'));
      expect(keys, contains('erp_menu_finance_contributions'));
    });

    test(
      'TREASURER no Brasil vê o módulo, mas não a seção de Configurações',
      () {
        final sections = menuItems(['TREASURER'], 'BR');
        final keys = visibleKeys(sections);

        expect(keys, contains(recurringKey));
        expect(
          sections.map((section) => section['key']),
          isNot(contains('erp_menu_settings')),
        );
      },
    );

    test('sem papéis reconhecidos o menu fica vazio', () {
      expect(menuItems([], 'BR'), isEmpty);
      expect(menuItems(['MEMBER'], 'BR'), isEmpty);
    });
  });
}
