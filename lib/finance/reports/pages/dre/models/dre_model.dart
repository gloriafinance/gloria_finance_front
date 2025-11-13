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

/// Modelo de respuesta DRE según la especificación OpenAPI
class DREModel {
  final double receitaBruta;
  final double receitaLiquida;
  final double custosDiretos;
  final double resultadoBruto;
  final double despesasOperacionais;
  final double resultadoOperacional;
  final double resultadosExtraordinarios;
  final double resultadoLiquido;

  DREModel({
    required this.receitaBruta,
    required this.receitaLiquida,
    required this.custosDiretos,
    required this.resultadoBruto,
    required this.despesasOperacionais,
    required this.resultadoOperacional,
    required this.resultadosExtraordinarios,
    required this.resultadoLiquido,
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
      resultadoOperacional: _toDouble(json['resultadoOperacional']),
      resultadosExtraordinarios: _toDouble(json['resultadosExtraordinarios']),
      resultadoLiquido: _toDouble(json['resultadoLiquido']),
    );
  }

  factory DREModel.empty() {
    return DREModel(
      receitaBruta: 0,
      receitaLiquida: 0,
      custosDiretos: 0,
      resultadoBruto: 0,
      despesasOperacionais: 0,
      resultadoOperacional: 0,
      resultadosExtraordinarios: 0,
      resultadoLiquido: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receitaBruta': receitaBruta,
      'receitaLiquida': receitaLiquida,
      'custosDiretos': custosDiretos,
      'resultadoBruto': resultadoBruto,
      'despesasOperacionais': despesasOperacionais,
      'resultadoOperacional': resultadoOperacional,
      'resultadosExtraordinarios': resultadosExtraordinarios,
      'resultadoLiquido': resultadoLiquido,
    };
  }
}
