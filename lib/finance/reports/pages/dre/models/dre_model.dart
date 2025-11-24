// lib/finance/reports/pages/dre/models/dre_model.dart

double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value.toString()) ?? 0;
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

/// Modelo de respuesta DRE según la especificación OpenAPI
class DREModel {
  final double receitaBruta;
  final double receitaLiquida;
  final double custosDiretos;
  final double resultadoBruto;
  final double despesasOperacionais;
  final double repassesMinisteriais;
  final double investimentosCAPEX;
  final double resultadoOperacional;
  final double resultadosExtraordinarios;
  final double resultadoLiquido;
  final int? year;
  final int? month;

  DREModel({
    required this.receitaBruta,
    required this.receitaLiquida,
    required this.custosDiretos,
    required this.resultadoBruto,
    required this.despesasOperacionais,
    required this.repassesMinisteriais,
    required this.investimentosCAPEX,
    required this.resultadoOperacional,
    required this.resultadosExtraordinarios,
    required this.resultadoLiquido,
    required this.year,
    required this.month,
  });

  factory DREModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DREModel.empty();
    }

    return DREModel(
      receitaBruta: _toDouble(json['receitaBruta']),
      receitaLiquida: _toDouble(json['receitaLiquida']),
      custosDiretos: _toDouble(json['custosDiretos']),
      resultadoBruto: _toDouble(json['resultadoBruto']),
      despesasOperacionais: _toDouble(json['despesasOperacionais']),
      repassesMinisteriais: _toDouble(json['repassesMinisteriais']),
      investimentosCAPEX: _toDouble(json['investimentosCAPEX']),
      resultadoOperacional: _toDouble(json['resultadoOperacional']),
      resultadosExtraordinarios: _toDouble(json['resultadosExtraordinarios']),
      resultadoLiquido: _toDouble(json['resultadoLiquido']),
      year: _toInt(json['year']),
      month: _toInt(json['month']),
    );
  }

  factory DREModel.empty() {
    return DREModel(
      receitaBruta: 0,
      receitaLiquida: 0,
      custosDiretos: 0,
      resultadoBruto: 0,
      despesasOperacionais: 0,
      repassesMinisteriais: 0,
      investimentosCAPEX: 0,
      resultadoOperacional: 0,
      resultadosExtraordinarios: 0,
      resultadoLiquido: 0,
      year: null,
      month: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receitaBruta': receitaBruta,
      'receitaLiquida': receitaLiquida,
      'custosDiretos': custosDiretos,
      'resultadoBruto': resultadoBruto,
      'despesasOperacionais': despesasOperacionais,
      'repassesMinisteriais': repassesMinisteriais,
      'investimentosCAPEX': investimentosCAPEX,
      'resultadoOperacional': resultadoOperacional,
      'resultadosExtraordinarios': resultadosExtraordinarios,
      'resultadoLiquido': resultadoLiquido,
      'year': year,
      'month': month,
    };
  }
}
