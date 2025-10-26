import 'dart:convert';

import 'package:church_finance_bk/helpers/date_formatter.dart';
import 'package:dio/dio.dart';

import '../../../../models/patrimony_asset_enums.dart';
import '../../../../models/patrimony_attachment_model.dart';

class PatrimonyAssetFormState {
  final bool loadingAsset;
  final bool makeRequest;
  final String? assetId;
  final String name;
  final String? category;
  final double value;
  final String valueText;
  final String acquisitionDate;
  final String churchId;
  final String location;
  final String responsibleId;
  final String? status;
  final String notes;
  final List<MultipartFile> newAttachments;
  final List<PatrimonyAttachmentModel> existingAttachments;
  final Set<String> attachmentsToRemove;

  const PatrimonyAssetFormState({
    required this.loadingAsset,
    required this.makeRequest,
    required this.assetId,
    required this.name,
    required this.category,
    required this.value,
    required this.valueText,
    required this.acquisitionDate,
    required this.churchId,
    required this.location,
    required this.responsibleId,
    required this.status,
    required this.notes,
    required this.newAttachments,
    required this.existingAttachments,
    required this.attachmentsToRemove,
  });

  factory PatrimonyAssetFormState.initial() {
    return const PatrimonyAssetFormState(
      loadingAsset: false,
      makeRequest: false,
      assetId: null,
      name: '',
      category: null,
      value: 0,
      valueText: '',
      acquisitionDate: '',
      churchId: '',
      location: '',
      responsibleId: '',
      status: null,
      notes: '',
      newAttachments: [],
      existingAttachments: [],
      attachmentsToRemove: {},
    );
  }

  bool get isEditing => assetId != null;

  String? get categoryLabel {
    if (category == null) {
      return null;
    }

    return PatrimonyAssetCategory.values
        .firstWhere((element) => element.apiValue == category,
            orElse: () => PatrimonyAssetCategory.other)
        .label;
  }

  String? get statusLabel {
    if (status == null) {
      return null;
    }

    return PatrimonyAssetStatus.values
        .firstWhere((element) => element.apiValue == status,
            orElse: () => PatrimonyAssetStatus.active)
        .label;
  }

  PatrimonyAssetFormState copyWith({
    bool? loadingAsset,
    bool? makeRequest,
    String? assetId,
    String? name,
    String? category,
    double? value,
    String? valueText,
    String? acquisitionDate,
    String? churchId,
    String? location,
    String? responsibleId,
    String? status,
    bool clearStatus = false,
    String? notes,
    List<MultipartFile>? newAttachments,
    List<PatrimonyAttachmentModel>? existingAttachments,
    Set<String>? attachmentsToRemove,
  }) {
    return PatrimonyAssetFormState(
      loadingAsset: loadingAsset ?? this.loadingAsset,
      makeRequest: makeRequest ?? this.makeRequest,
      assetId: assetId ?? this.assetId,
      name: name ?? this.name,
      category: category ?? this.category,
      value: value ?? this.value,
      valueText: valueText ?? this.valueText,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      churchId: churchId ?? this.churchId,
      location: location ?? this.location,
      responsibleId: responsibleId ?? this.responsibleId,
      status: clearStatus ? null : (status ?? this.status),
      notes: notes ?? this.notes,
      newAttachments: newAttachments ?? this.newAttachments,
      existingAttachments: existingAttachments ?? this.existingAttachments,
      attachmentsToRemove: attachmentsToRemove ?? this.attachmentsToRemove,
    );
  }

  FormData toFormData() {
    final formData = FormData();

    formData.fields
      ..add(MapEntry('name', name))
      ..add(MapEntry('value', value.toString()))
      ..add(MapEntry('churchId', churchId))
      ..add(MapEntry('location', location))
      ..add(MapEntry('responsibleId', responsibleId));

    if (acquisitionDate.isNotEmpty) {
      formData.fields
          .add(MapEntry('acquisitionDate', convertDateFormat(acquisitionDate)));
    }

    if (status != null && status!.isNotEmpty) {
      formData.fields.add(MapEntry('status', status!));
    }

    formData.fields.add(MapEntry(
        'category', category ?? PatrimonyAssetCategory.other.apiValue));

    if (notes.isNotEmpty) {
      formData.fields.add(MapEntry('notes', notes));
    }

    if (existingAttachments.isNotEmpty) {
      formData.fields.add(
        MapEntry(
          'attachments',
          jsonEncode(existingAttachments.map((e) => e.toMap()).toList()),
        ),
      );
    }

    for (final removeId in attachmentsToRemove) {
      formData.fields.add(MapEntry('attachmentsToRemove', removeId));
    }

    for (final attachment in newAttachments) {
      formData.files.add(MapEntry('attachments', attachment));
    }

    return formData;
  }
}
