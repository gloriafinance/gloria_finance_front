import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';

import 'patrimony_asset_enums.dart';
import 'patrimony_attachment_model.dart';
import 'patrimony_history_entry.dart';
import 'patrimony_member_summary.dart';

class PatrimonyAssetModel {
  final String assetId;
  final String code;
  final String name;
  final PatrimonyAssetCategory? category;
  final DateTime? acquisitionDate;
  final double value;
  final int quantity;
  final String churchId;
  final String? location;
  final String? responsibleId;
  final PatrimonyAssetStatus? status;
  final List<PatrimonyAttachmentModel> attachments;
  final List<PatrimonyHistoryEntry> history;
  final bool documentsPending;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? disposalStatus;
  final String? disposalReason;
  final String? disposalPerformedBy;
  final DateTime? disposalOccurredAt;
  final String? disposalNotes;
  final PatrimonyInventoryStatus? inventoryStatus;
  final DateTime? inventoryCheckedAt;
  final PatrimonyMemberSummary? inventoryCheckedBy;
  final String? inventoryNotes;

  PatrimonyAssetModel({
    required this.assetId,
    required this.code,
    required this.name,
    required this.category,
    required this.acquisitionDate,
    required this.value,
    required this.quantity,
    required this.churchId,
    this.location,
    this.responsibleId,
    required this.status,
    required this.attachments,
    required this.history,
    required this.documentsPending,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.disposalStatus,
    this.disposalReason,
    this.disposalPerformedBy,
    this.disposalOccurredAt,
    this.disposalNotes,
    this.inventoryStatus,
    this.inventoryCheckedAt,
    this.inventoryCheckedBy,
    this.inventoryNotes,
  });

  factory PatrimonyAssetModel.fromMap(Map<String, dynamic> map) {
    final attachments =
        (map['attachments'] as List?)
            ?.map(
              (attachment) => PatrimonyAttachmentModel.fromMap(
                Map<String, dynamic>.from(attachment as Map<dynamic, dynamic>),
              ),
            )
            .toList() ??
        [];

    final history =
        (map['history'] as List?)
            ?.map(
              (entry) => PatrimonyHistoryEntry.fromMap(
                Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
              ),
            )
            .toList() ??
        [];

    final disposal = map['disposal'] as Map?;

    return PatrimonyAssetModel(
      assetId: map['assetId'] as String? ?? '',
      code: map['code'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: PatrimonyAssetCategory.fromApiValue(map['category'] as String?),
      acquisitionDate:
          map['acquisitionDate'] != null
              ? DateTime.tryParse(map['acquisitionDate'] as String)
              : null,
      value:
          map['value'] is num
              ? (map['value'] as num).toDouble()
              : double.tryParse('${map['value']}') ?? 0,
      quantity:
          map['quantity'] is num
              ? (map['quantity'] as num).toInt()
              : int.tryParse('${map['quantity']}') ?? 0,
      churchId: map['churchId'] as String? ?? '',
      location: map['location'] as String?,
      responsibleId: map['responsibleId'] as String?,
      status: PatrimonyAssetStatus.fromApiValue(map['status'] as String?),
      attachments: attachments,
      history: history,
      documentsPending: map['documentsPending'] as bool? ?? false,
      notes: map['notes'] as String?,
      createdAt:
          map['createdAt'] != null
              ? DateTime.tryParse(map['createdAt'] as String)
              : null,
      updatedAt:
          map['updatedAt'] != null
              ? DateTime.tryParse(map['updatedAt'] as String)
              : null,
      disposalStatus: disposal?['status'] as String?,
      disposalReason: disposal?['reason'] as String?,
      disposalPerformedBy: disposal?['performedBy'] as String?,
      disposalOccurredAt:
          disposal?['occurredAt'] != null
              ? DateTime.tryParse(disposal?['occurredAt'] as String)
              : null,
      disposalNotes: disposal?['notes'] as String?,
      inventoryStatus: PatrimonyInventoryStatus.fromApiValue(
        map['inventoryStatus'] as String?,
      ),
      inventoryCheckedAt:
          map['inventoryCheckedAt'] != null
              ? DateTime.tryParse(map['inventoryCheckedAt'] as String)
              : null,
      inventoryCheckedBy:
          map['inventoryCheckedBy'] != null
              ? PatrimonyMemberSummary.fromMap(
                Map<String, dynamic>.from(map['inventoryCheckedBy'] as Map),
              )
              : null,
      inventoryNotes: map['inventoryNotes'] as String?,
    );
  }

  String get categoryLabel => category?.label ?? 'Outros';

  String get statusLabel => status?.label ?? '';

  String get acquisitionDateLabel =>
      acquisitionDate != null
          ? convertDateFormatToDDMMYYYY(acquisitionDate!.toIso8601String())
          : '';

  String get valueLabel => CurrencyFormatter.formatCurrency(value);

  String get quantityLabel => quantity > 0 ? '$quantity' : '';

  bool get hasDisposal => disposalStatus != null && disposalStatus!.isNotEmpty;

  String get disposalStatusLabel =>
      PatrimonyAssetStatus.fromApiValue(disposalStatus)?.label ?? '';

  String get disposalDateLabel =>
      disposalOccurredAt != null
          ? convertDateFormatToDDMMYYYY(disposalOccurredAt!.toIso8601String())
          : '';

  String get inventoryStatusLabel => inventoryStatus?.label ?? '';

  String get inventoryCheckedAtLabel =>
      inventoryCheckedAt != null
          ? convertDateFormatToDDMMYYYY(inventoryCheckedAt!.toIso8601String())
          : '';
}
