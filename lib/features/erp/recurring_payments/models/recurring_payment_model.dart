import 'package:gloria_finance/l10n/app_localizations.dart';

/// Tipo de valor de una recurrencia. Define si la configuración exige un valor
/// permanente (`FIXED`) o si el valor se informa en cada ejecución
/// (`VARIABLE`). Contrato: `RecurringPaymentConfigurationData.type`.
enum RecurringPaymentValueType { FIXED, VARIABLE }

extension RecurringPaymentValueTypeExtension on RecurringPaymentValueType {
  String get apiValue => toString().split('.').last;

  /// Devuelve `null` cuando el valor no pertenece al contrato.
  ///
  /// No se inventa un tipo por defecto: si la API introdujera un valor nuevo,
  /// mostrar `FIXED` y volver a guardar sobrescribiría la configuración real.
  /// El formulario, en ese caso, obliga a elegir un tipo.
  static RecurringPaymentValueType? tryFromApiValue(String? value) {
    for (final element in RecurringPaymentValueType.values) {
      if (element.apiValue == value) return element;
    }
    return null;
  }

  String friendlyName(AppLocalizations l10n) {
    switch (this) {
      case RecurringPaymentValueType.FIXED:
        return l10n.recurringPayments_type_fixed;
      case RecurringPaymentValueType.VARIABLE:
        return l10n.recurringPayments_type_variable;
    }
  }
}

/// Estado permanente de la recurrencia. Contrato:
/// `RecurringPaymentConfigurationData.status`.
enum RecurringPaymentStatus { ACTIVE, INACTIVE }

extension RecurringPaymentStatusExtension on RecurringPaymentStatus {
  String get apiValue => toString().split('.').last;

  /// `null` cuando el valor no pertenece al contrato (ver
  /// [RecurringPaymentValueTypeExtension.tryFromApiValue]).
  static RecurringPaymentStatus? tryFromApiValue(String? value) {
    for (final element in RecurringPaymentStatus.values) {
      if (element.apiValue == value) return element;
    }
    return null;
  }

  bool get isActive => this == RecurringPaymentStatus.ACTIVE;

  RecurringPaymentStatus get flipped =>
      isActive
          ? RecurringPaymentStatus.INACTIVE
          : RecurringPaymentStatus.ACTIVE;

  String friendlyName(AppLocalizations l10n) {
    return isActive
        ? l10n.settings_church_profile_status_active
        : l10n.settings_church_profile_status_inactive;
  }
}

/// Tipos de clave PIX aceptados por el dominio. Los valores son códigos técnicos,
/// no copy traducible.
enum PixKeyType { CPF, CNPJ, EMAIL, PHONE, EVP }

extension PixKeyTypeExtension on PixKeyType {
  String get apiValue => toString().split('.').last;

  /// `null` cuando el valor no pertenece al contrato.
  static PixKeyType? tryFromApiValue(String? value) {
    for (final element in PixKeyType.values) {
      if (element.apiValue == value) return element;
    }
    return null;
  }

  static List<String> get listApiValues =>
      PixKeyType.values.map((element) => element.apiValue).toList();
}

/// Destino PIX reutilizable opcional.
///
/// Es metadato del beneficiario, NO un método de pago: una recurrencia con
/// `pixDestination` puede ejecutarse como boleto y viceversa.
class RecurringPixDestination {
  final String pixKey;

  /// `null` si la API devolvió un tipo de clave que este cliente no conoce: la
  /// clave se muestra, pero el formulario exige elegir un tipo antes de guardar.
  final PixKeyType? pixKeyType;

  const RecurringPixDestination({required this.pixKey, this.pixKeyType});

  factory RecurringPixDestination.fromJson(Map<String, dynamic> json) {
    return RecurringPixDestination(
      pixKey: json['pixKey'] ?? '',
      pixKeyType: PixKeyTypeExtension.tryFromApiValue(
        json['pixKeyType'] as String?,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'pixKey': pixKey,
    'pixKeyType': pixKeyType?.apiValue,
  };
}

/// Configuración permanente de un pago recurrente.
///
/// Contrato de lectura/escritura: `RecurringPaymentConfigurationData` de la API
/// (`src/Financial/domain/RecurringPayments.ts`). No existe método de pago
/// aquí: PIX/boleto pertenece a una ejecución, no a esta configuración.
class RecurringPaymentModel {
  final String recurringPaymentId;
  final String churchId;
  final String name;
  final String financialConceptId;
  final String costCenterId;

  /// `null` cuando la API devolvió un tipo fuera del contrato conocido.
  final RecurringPaymentValueType? type;

  final double? amount;
  final int dayOfMonth;

  /// `null` cuando la API devolvió un estado fuera del contrato conocido.
  final RecurringPaymentStatus? status;

  final RecurringPixDestination? pixDestination;

  const RecurringPaymentModel({
    required this.recurringPaymentId,
    required this.churchId,
    required this.name,
    required this.financialConceptId,
    required this.costCenterId,
    required this.type,
    required this.amount,
    required this.dayOfMonth,
    required this.status,
    required this.pixDestination,
  });

  factory RecurringPaymentModel.fromJson(Map<String, dynamic> json) {
    final rawPixDestination = json['pixDestination'];

    return RecurringPaymentModel(
      recurringPaymentId: json['recurringPaymentId'] ?? '',
      churchId: json['churchId'] ?? '',
      name: json['name'] ?? '',
      financialConceptId: json['financialConceptId'] ?? '',
      costCenterId: json['costCenterId'] ?? '',
      type: RecurringPaymentValueTypeExtension.tryFromApiValue(
        json['type'] as String?,
      ),
      amount:
          json['amount'] == null ? null : (json['amount'] as num).toDouble(),
      dayOfMonth: json['dayOfMonth'] ?? 1,
      status: RecurringPaymentStatusExtension.tryFromApiValue(
        json['status'] as String?,
      ),
      pixDestination:
          rawPixDestination is Map
              ? RecurringPixDestination.fromJson(
                Map<String, dynamic>.from(rawPixDestination),
              )
              : null,
    );
  }

  bool get isFixed => type == RecurringPaymentValueType.FIXED;

  bool get isActive => status == RecurringPaymentStatus.ACTIVE;

  bool get hasPixDestination => pixDestination != null;

  RecurringPaymentModel copyWith({
    String? name,
    String? financialConceptId,
    String? costCenterId,
    RecurringPaymentValueType? type,
    double? amount,
    bool clearAmount = false,
    int? dayOfMonth,
    RecurringPaymentStatus? status,
    RecurringPixDestination? pixDestination,
    bool clearPixDestination = false,
  }) {
    return RecurringPaymentModel(
      recurringPaymentId: recurringPaymentId,
      churchId: churchId,
      name: name ?? this.name,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      costCenterId: costCenterId ?? this.costCenterId,
      type: type ?? this.type,
      amount: clearAmount ? null : (amount ?? this.amount),
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      status: status ?? this.status,
      pixDestination:
          clearPixDestination ? null : (pixDestination ?? this.pixDestination),
    );
  }

  /// Payload de `POST /recurring-payments` y `PUT /recurring-payments/:id`.
  ///
  /// Requiere un `type` conocido: el formulario obliga a elegirlo cuando la API
  /// devolvió un valor desconocido.
  Map<String, dynamic> toConfigurationJson({String? name}) {
    final knownType = type;
    if (knownType == null) {
      throw StateError('RecurringPaymentModel has no known type');
    }

    return RecurringPaymentConfigurationPayload.build(
      name: name ?? this.name,
      financialConceptId: financialConceptId,
      costCenterId: costCenterId,
      type: knownType,
      amount: amount,
      dayOfMonth: dayOfMonth,
      status: status,
      pixDestination: pixDestination,
    );
  }
}

/// Dueño único de la forma del payload de configuración.
///
/// Existe para que el modelo leído de la API y el formulario armen exactamente el
/// mismo contrato, sin duplicar las reglas de `amount`, `status` y
/// `pixDestination`.
class RecurringPaymentConfigurationPayload {
  const RecurringPaymentConfigurationPayload._();

  static Map<String, dynamic> build({
    required String name,
    required String financialConceptId,
    required String costCenterId,
    required RecurringPaymentValueType type,
    required double? amount,
    required int dayOfMonth,
    required RecurringPaymentStatus? status,
    required RecurringPixDestination? pixDestination,
  }) {
    final isFixed = type == RecurringPaymentValueType.FIXED;

    return {
      'name': name,
      'financialConceptId': financialConceptId,
      'costCenterId': costCenterId,
      'type': type.apiValue,
      // `amount` es obligatorio en FIXED y prohibido en VARIABLE en el dominio.
      if (isFixed && amount != null) 'amount': amount,
      'dayOfMonth': dayOfMonth,
      // `status` se omite cuando no se conoce: el backend conserva el actual
      // (`request.status ?? existing.getStatus()`), así que no se inventa uno.
      if (status != null) 'status': status.apiValue,
      if (pixDestination != null && pixDestination.pixKeyType != null)
        'pixDestination': pixDestination.toJson(),
    };
  }
}
