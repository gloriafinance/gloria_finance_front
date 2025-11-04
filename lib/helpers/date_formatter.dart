import 'package:flutter/material.dart';

DateTime? parseIsoDate(dynamic value) {
  if (value == null) return null;
  final stringValue = value.toString();
  if (stringValue.isEmpty || stringValue == 'null') {
    return null;
  }
  return DateTime.tryParse(stringValue);
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
    helpText: 'Selecionando uma data',
  );
}
