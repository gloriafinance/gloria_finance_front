import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:church_finance_bk/helpers/date_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../models/patrimony_asset_enums.dart';
import '../../../../models/patrimony_asset_model.dart';
import '../../../../models/patrimony_attachment_model.dart';
import '../../../../services/patrimony_service.dart';
import '../state/patrimony_asset_form_state.dart';

class PatrimonyAssetFormStore extends ChangeNotifier {
  PatrimonyAssetFormState state = PatrimonyAssetFormState.initial();
  final PatrimonyService service;

  PatrimonyAssetFormStore({PatrimonyService? service})
      : service = service ?? PatrimonyService();

  void setName(String value) {
    state = state.copyWith(name: value);
    notifyListeners();
  }

  void setCategoryByLabel(String? label) {
    final apiValue = PatrimonyAssetCategoryCollection.apiValueFromLabel(label);
    state = state.copyWith(category: apiValue);
    notifyListeners();
  }

  void setValueFromInput(String valueText) {
    if (valueText.isEmpty) {
      state = state.copyWith(value: 0, valueText: '');
    } else {
      final parsed = CurrencyFormatter.cleanCurrency(valueText);
      state = state.copyWith(value: parsed, valueText: valueText);
    }
    notifyListeners();
  }

  void setAcquisitionDate(String date) {
    state = state.copyWith(acquisitionDate: date);
    notifyListeners();
  }

  void setChurchId(String value) {
    state = state.copyWith(churchId: value);
    notifyListeners();
  }

  void setLocation(String value) {
    state = state.copyWith(location: value);
    notifyListeners();
  }

  void setResponsibleId(String value) {
    state = state.copyWith(responsibleId: value);
    notifyListeners();
  }

  void setStatusByLabel(String? label) {
    final apiValue = PatrimonyAssetStatusCollection.apiValueFromLabel(label);
    state = state.copyWith(status: apiValue, clearStatus: label == null);
    notifyListeners();
  }

  void setNotes(String value) {
    state = state.copyWith(notes: value);
    notifyListeners();
  }

  bool addAttachment(MultipartFile file) {
    final totalAttachments =
        state.newAttachments.length + state.existingAttachments.length;
    if (totalAttachments >= 3) {
      return false;
    }

    final updated = List<MultipartFile>.from(state.newAttachments)..add(file);
    state = state.copyWith(newAttachments: updated);
    notifyListeners();
    return true;
  }

  void removeNewAttachmentAt(int index) {
    final updated = List<MultipartFile>.from(state.newAttachments)..removeAt(index);
    state = state.copyWith(newAttachments: updated);
    notifyListeners();
  }

  void removeExistingAttachment(String attachmentId) {
    final updatedExisting = List<PatrimonyAttachmentModel>.from(state.existingAttachments)
      ..removeWhere((element) => element.attachmentId == attachmentId);
    final updatedRemove = Set<String>.from(state.attachmentsToRemove)
      ..add(attachmentId);

    state = state.copyWith(
      existingAttachments: updatedExisting,
      attachmentsToRemove: updatedRemove,
    );
    notifyListeners();
  }

  Future<void> loadAsset(String assetId) async {
    state = state.copyWith(loadingAsset: true);
    notifyListeners();

    try {
      final asset = await service.getAsset(assetId);
      _populateFromAsset(asset);
    } catch (e) {
      // A mensagem de erro já é tratada pelo AppHttp.transformResponse.
    } finally {
      state = state.copyWith(loadingAsset: false);
      notifyListeners();
    }
  }

  Future<bool> submit() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final payload = state.toFormData();
      if (state.isEditing && state.assetId != null) {
        await service.updateAsset(state.assetId!, payload);
        state = state.copyWith(
          makeRequest: false,
          newAttachments: [],
          attachmentsToRemove: {},
        );
      } else {
        await service.createAsset(payload);
        state = PatrimonyAssetFormState.initial();
      }

      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(makeRequest: false);
      notifyListeners();
      return false;
    }
  }

  void _populateFromAsset(PatrimonyAssetModel asset) {
    final acquisition = asset.acquisitionDate != null
        ? convertDateFormatToDDMMYYYY(asset.acquisitionDate!.toIso8601String())
        : '';

    final valueFormatted = CurrencyFormatter.formatCurrency(asset.value);

    state = state.copyWith(
      assetId: asset.assetId,
      name: asset.name,
      category: asset.category?.apiValue,
      value: asset.value,
      valueText: valueFormatted,
      acquisitionDate: acquisition,
      churchId: asset.churchId,
      location: asset.location ?? '',
      responsibleId: asset.responsibleId ?? '',
      status: asset.status?.apiValue,
      notes: asset.notes ?? '',
      existingAttachments: List<PatrimonyAttachmentModel>.from(asset.attachments),
      attachmentsToRemove: {},
      newAttachments: [],
    );
  }
}
