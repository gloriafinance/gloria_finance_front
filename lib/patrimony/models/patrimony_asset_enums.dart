enum PatrimonyAssetStatus {
  active('ACTIVE', 'Ativo'),
  maintenance('MAINTENANCE', 'Em manutenção'),
  inactive('INACTIVE', 'Inativo'),
  archived('ARCHIVED', 'Arquivado'),
  disposed('DISPOSED', 'Baixado');

  final String apiValue;
  final String label;

  const PatrimonyAssetStatus(this.apiValue, this.label);

  static PatrimonyAssetStatus? fromApiValue(String? value) {
    if (value == null) {
      return null;
    }

    return PatrimonyAssetStatus.values.firstWhere(
      (status) => status.apiValue.toUpperCase() == value.toUpperCase(),
      orElse: () => PatrimonyAssetStatus.active,
    );
  }
}

enum PatrimonyAssetCategory {
  instrument('instrument', 'Instrumentos'),
  vehicle('vehicle', 'Veículos'),
  furniture('furniture', 'Mobília'),
  electronics('electronics', 'Eletrônicos'),
  property('property', 'Imóveis'),
  supplies('supplies', 'Suprimentos'),
  other('other', 'Outros');

  final String apiValue;
  final String label;

  const PatrimonyAssetCategory(this.apiValue, this.label);

  static PatrimonyAssetCategory? fromApiValue(String? value) {
    if (value == null) {
      return null;
    }

    return PatrimonyAssetCategory.values.firstWhere(
      (category) => category.apiValue.toLowerCase() == value.toLowerCase(),
      orElse: () => PatrimonyAssetCategory.other,
    );
  }
}

extension PatrimonyAssetStatusCollection on PatrimonyAssetStatus {
  static List<String> labels() =>
      PatrimonyAssetStatus.values.map((status) => status.label).toList();

  static String? apiValueFromLabel(String? label) {
    if (label == null) {
      return null;
    }

    return PatrimonyAssetStatus.values
        .firstWhere((status) => status.label == label,
            orElse: () => PatrimonyAssetStatus.active)
        .apiValue;
  }
}

extension PatrimonyAssetCategoryCollection on PatrimonyAssetCategory {
  static List<String> labels() =>
      PatrimonyAssetCategory.values.map((category) => category.label).toList();

  static String? apiValueFromLabel(String? label) {
    if (label == null) {
      return null;
    }

    return PatrimonyAssetCategory.values
        .firstWhere((category) => category.label == label,
            orElse: () => PatrimonyAssetCategory.other)
        .apiValue;
  }
}
