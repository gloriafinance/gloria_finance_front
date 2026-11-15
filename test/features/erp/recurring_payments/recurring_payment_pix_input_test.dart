import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_form_store.dart';
import 'package:gloria_finance/features/erp/recurring_payments/utils/recurring_payment_pix_input.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

/// O tipo da chave PIX é escolhido **antes** da chave e define o formato do
/// campo: CPF, CNPJ e telefone têm máscara; e-mail e EVP são texto livre.
void main() {
  String applyMask(PixKeyType type, String digits) {
    final formatters = pixKeyInputFormatters(type);
    var value = TextEditingValue.empty;
    for (final formatter in formatters) {
      value = formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: digits),
      );
    }
    return value.text;
  }

  group('máscara por tipo de chave', () {
    test('CPF formata como 000.000.000-00', () {
      expect(pixKeyInputFormatters(PixKeyType.CPF), hasLength(1));
      expect(applyMask(PixKeyType.CPF, '12345678901'), '123.456.789-01');
    });

    test('CNPJ formata como 00.000.000/0000-00', () {
      expect(pixKeyInputFormatters(PixKeyType.CNPJ), hasLength(1));
      expect(
        applyMask(PixKeyType.CNPJ, '12345678000190'),
        '12.345.678/0001-90',
      );
    });

    test('telefone formata como (00) 00000-0000', () {
      expect(pixKeyInputFormatters(PixKeyType.PHONE), hasLength(1));
      expect(applyMask(PixKeyType.PHONE, '11988887777'), '(11) 98888-7777');
    });

    test('e-mail e EVP ficam sem máscara, para não truncar o valor', () {
      expect(pixKeyInputFormatters(PixKeyType.EMAIL), isEmpty);
      expect(pixKeyInputFormatters(PixKeyType.EVP), isEmpty);
    });

    test('o teclado acompanha o tipo', () {
      expect(pixKeyKeyboardType(PixKeyType.CPF), TextInputType.number);
      expect(pixKeyKeyboardType(PixKeyType.CNPJ), TextInputType.number);
      expect(pixKeyKeyboardType(PixKeyType.PHONE), TextInputType.number);
      expect(pixKeyKeyboardType(PixKeyType.EMAIL), TextInputType.emailAddress);
      expect(pixKeyKeyboardType(PixKeyType.EVP), TextInputType.text);
    });

    test('as máscaras do pacote são MaskedInputFormatter', () {
      expect(
        pixKeyInputFormatters(PixKeyType.CPF).single,
        isA<MaskedInputFormatter>(),
      );
    });
  });

  group('RecurringPaymentFormStore · chave PIX', () {
    test('trocar o tipo limpa o valor digitado', () {
      final store = RecurringPaymentFormStore(symbolFormatMoney: 'R\$');

      store.setPixKey('123.456.789-01');
      expect(store.state.pixKey, '123.456.789-01');

      store.setPixKeyType(PixKeyType.CNPJ);

      expect(store.state.pixKeyType, PixKeyType.CNPJ);
      expect(store.state.pixKey, isEmpty);
    });
  });
}
