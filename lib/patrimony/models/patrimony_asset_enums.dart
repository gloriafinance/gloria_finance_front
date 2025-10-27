enum PatrimonyAssetStatus {
  active('ACTIVE', 'Ativo'),
  maintenance('MAINTENANCE', 'Em manutenção'),
  inactive('INACTIVE', 'Inativo'),
  archived('ARCHIVED', 'Arquivado'),
  donated('DONATED', 'Doado'),
  sold('SOLD', 'Vendido'),
  lost('LOST', 'Extraviado'),
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

  bool get isDisposal =>
      this == PatrimonyAssetStatus.donated ||
      this == PatrimonyAssetStatus.sold ||
      this == PatrimonyAssetStatus.lost ||
      this == PatrimonyAssetStatus.disposed;
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
  static List<String> labels({bool includeDisposal = true}) =>
      PatrimonyAssetStatus.values
          .where((status) => includeDisposal || !status.isDisposal)
          .map((status) => status.label)
          .toList();

  static String? apiValueFromLabel(String? label) {
    if (label == null) {
      return null;
    }

    return PatrimonyAssetStatus.values
        .firstWhere((status) => status.label == label,
            orElse: () => PatrimonyAssetStatus.active)
        .apiValue;
  }

  static List<String> disposalLabels() => PatrimonyAssetStatus.values
      .where((status) => status == PatrimonyAssetStatus.donated ||
          status == PatrimonyAssetStatus.sold ||
          status == PatrimonyAssetStatus.lost)
      .map((status) => status.label)
      .toList();

  static String? disposalApiValueFromLabel(String? label) {
    if (label == null) {
      return null;
    }

    return PatrimonyAssetStatus.values
        .where((status) =>
            status == PatrimonyAssetStatus.donated ||
            status == PatrimonyAssetStatus.sold ||
            status == PatrimonyAssetStatus.lost)
        .firstWhere((status) => status.label == label,
            orElse: () => PatrimonyAssetStatus.donated)
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

enum PatrimonyInventoryStatus {
  confirmed('CONFIRMED', 'Conferido'),
  notFound('NOT_FOUND', 'Não encontrado');

  final String apiValue;
  final String label;

  const PatrimonyInventoryStatus(this.apiValue, this.label);

  static PatrimonyInventoryStatus? fromApiValue(String? value) {
    if (value == null) {
      return null;
    }

    return PatrimonyInventoryStatus.values.firstWhere(
      (status) => status.apiValue.toUpperCase() == value.toUpperCase(),
      orElse: () => PatrimonyInventoryStatus.confirmed,
    );
  }
}

extension PatrimonyInventoryStatusCollection on PatrimonyInventoryStatus {
  static List<String> labels() => PatrimonyInventoryStatus.values
      .map((status) => status.label)
      .toList();

  static String? apiValueFromLabel(String? label) {
    if (label == null) {
      return null;
    }

    return PatrimonyInventoryStatus.values
        .firstWhere((status) => status.label == label,
            orElse: () => PatrimonyInventoryStatus.confirmed)
        .apiValue;
  }
}
