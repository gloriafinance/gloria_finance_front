import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:church_finance_bk/helpers/date_formatter.dart';

import 'patrimony_asset_enums.dart';
import 'patrimony_attachment_model.dart';
import 'patrimony_history_entry.dart';

class PatrimonyAssetModel {
  final String assetId;
  final String code;
  final String name;
  final PatrimonyAssetCategory? category;
  final DateTime? acquisitionDate;
  final double value;
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

  PatrimonyAssetModel({
    required this.assetId,
    required this.code,
    required this.name,
    required this.category,
    required this.acquisitionDate,
    required this.value,
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
  });

  factory PatrimonyAssetModel.fromMap(Map<String, dynamic> map) {
    final attachments = (map['attachments'] as List?)
            ?.map((attachment) =>
                PatrimonyAttachmentModel.fromMap(Map<String, dynamic>.from(
                    attachment as Map<dynamic, dynamic>)))
            .toList() ??
        [];

    final history = (map['history'] as List?)
            ?.map((entry) => PatrimonyHistoryEntry.fromMap(
                Map<String, dynamic>.from(entry as Map<dynamic, dynamic>)))
            .toList() ??
        [];

    return PatrimonyAssetModel(
      assetId: map['assetId'] as String? ?? '',
      code: map['code'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: PatrimonyAssetCategory.fromApiValue(map['category'] as String?),
      acquisitionDate: map['acquisitionDate'] != null
          ? DateTime.tryParse(map['acquisitionDate'] as String)
          : null,
      value: map['value'] is num
          ? (map['value'] as num).toDouble()
          : double.tryParse('${map['value']}') ?? 0,
      churchId: map['churchId'] as String? ?? '',
      location: map['location'] as String?,
      responsibleId: map['responsibleId'] as String?,
      status: PatrimonyAssetStatus.fromApiValue(map['status'] as String?),
      attachments: attachments,
      history: history,
      documentsPending: map['documentsPending'] as bool? ?? false,
      notes: map['notes'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }

  String get categoryLabel => category?.label ?? 'Outros';

  String get statusLabel => status?.label ?? '';

  String get acquisitionDateLabel =>
      acquisitionDate != null ? convertDateFormatToDDMMYYYY(acquisitionDate!.toIso8601String()) : '';

  String get valueLabel => CurrencyFormatter.formatCurrency(value);
}
