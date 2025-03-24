import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

enum CurrencyType { REAL, DOLLAR, SONIC, BITCOIN, USDT }

extension CurrencyTypeExtension on CurrencyType {
  String get apiValue {
    switch (this) {
      case CurrencyType.REAL:
        return 'R\$';
      case CurrencyType.DOLLAR:
        return '\$';
      case CurrencyType.SONIC:
        return 'S';
      case CurrencyType.BITCOIN:
        return '₿';
      case CurrencyType.USDT:
        return 'USDT';
    }
  }

  String get friendlyName {
    switch (this) {
      case CurrencyType.REAL:
        return 'Real';
      case CurrencyType.DOLLAR:
        return 'Dólar';
      case CurrencyType.SONIC:
        return 'Sonic';
      case CurrencyType.BITCOIN:
        return 'Bitcoin';
      case CurrencyType.USDT:
        return 'Tether';
    }
  }
}

class CurrencyFormatter {
  static final List<String> _fiatCurrencySymbols = [
    CurrencyType.REAL.apiValue,
    CurrencyType.DOLLAR.apiValue,
    CurrencyType.USDT.apiValue,
  ];

  static String formatCurrency(double amount, {String? symbol}) {
    if (symbol != null) {
      return '$symbol ${amount.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    }

    return 'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  static bool _isFiatCurrency(String symbol) {
    return _fiatCurrencySymbols.contains(symbol);
  }

  static CurrencyInputFormatter getInputFormatters(String symbol) {
    if (_isFiatCurrency(symbol)) {
      return _getFiatInputFormatters(symbol);
    }

    return _getCryptoInputFormatters(symbol);
  }

  static CurrencyInputFormatter _getFiatInputFormatters(String symbol) {
    return CurrencyInputFormatter(
      leadingSymbol: symbol,
      useSymbolPadding: true,
      mantissaLength: 2,
      thousandSeparator: ThousandSeparator.Period,
    );
  }

  static CurrencyInputFormatter _getCryptoInputFormatters(String symbol) {
    return CurrencyInputFormatter(
      leadingSymbol: symbol,
      useSymbolPadding: true,
      mantissaLength: 8,
      thousandSeparator: ThousandSeparator.SpaceAndPeriodMantissa,
    );
  }

  static double cleanCurrency(String value) {
    return double.parse(
        value.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.'));
  }
}
