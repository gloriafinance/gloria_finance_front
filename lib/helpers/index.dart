import 'package:flutter/material.dart';

String formatCurrency(double amount, {String? symbol}) {
  if (symbol != null) {
    return '$symbol ${amount.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  return 'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}

String convertDateFormat(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }

  // Verifica que la fecha tenga el formato correcto
  if (date.length != 10 || date[2] != '/' || date[5] != '/') {
    throw FormatException('Formato de fecha inválido');
  }

  // Divide la fecha en día, mes y año
  String day = date.substring(0, 2);
  String month = date.substring(3, 5);
  String year = date.substring(6, 10);

  // Retorna la fecha en el nuevo formato
  return '$year-$month-$day';
}

String convertDateFormatToDDMMYYYY(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }

  // Verifica que la fecha tenga el formato correcto
  if (date.length < 10 || date[4] != '-' || date[7] != '-') {
    throw FormatException('Formato de fecha inválido');
  }

  // Divide la fecha en año, mes y día
  String year = date.substring(0, 4);
  String month = date.substring(5, 7);
  String day = date.substring(8, 10);

  // Retorna la fecha en el nuevo formato
  return '$day/$month/$year';
}

Future<DateTime?> selectDate(BuildContext context) async {
  return await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    // Fecha inicial
    firstDate: DateTime(1940),
    // Fecha mínima
    lastDate: DateTime(2100),
    // Fecha máxima
    helpText: 'Selecciona una fecha',
  );
}

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 768;
}

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
