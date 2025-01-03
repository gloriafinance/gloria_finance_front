String convertDateFormat(String date) {
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
