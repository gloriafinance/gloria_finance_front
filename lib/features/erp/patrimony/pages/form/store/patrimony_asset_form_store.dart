import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

import '../../../models/patrimony_asset_enums.dart';
import '../../../models/patrimony_asset_model.dart';
import '../../../models/patrimony_attachment_model.dart';
import '../../../services/patrimony_service.dart';
import '../state/patrimony_asset_form_state.dart';

class PatrimonyAssetFormStore extends ChangeNotifier {
  PatrimonyAssetFormState state;
  final PatrimonyService service;

  PatrimonyAssetFormStore({
    PatrimonyService? service,
    PatrimonyAssetModel? asset,
    String? assetId,
  }) : service = service ?? PatrimonyService(),
       state =
           asset != null
               ? PatrimonyAssetFormState.fromModel(asset)
               : PatrimonyAssetFormState.initial().copyWith(assetId: assetId);

  void setName(String value) {
    state = state.copyWith(name: value);
    notifyListeners();
  }

  void setCode(String value) {
    state = state.copyWith(code: value.trim());
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

  void setQuantityFromInput(String valueText) {
    if (valueText.isEmpty) {
      state = state.copyWith(quantity: 0, quantityText: '');
    } else {
      final sanitized = valueText.replaceAll(RegExp(r'[^0-9]'), '');
      final parsed = int.tryParse(sanitized);
      state = state.copyWith(
        quantity: parsed ?? 0,
        quantityText: parsed != null ? parsed.toString() : sanitized,
      );
    }
    notifyListeners();
  }

  void setLocation(String value) {
    state = state.copyWith(location: value);
    notifyListeners();
  }

  void setResponsibleId(String? value) {
    state = state.copyWith(responsibleId: value ?? '');
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

  bool addAttachment(PatrimonyNewAttachment attachment) {
    final totalAttachments =
        state.newAttachments.length + state.existingAttachments.length;
    if (totalAttachments >= 3) {
      return false;
    }

    final updated = List<PatrimonyNewAttachment>.from(state.newAttachments)
      ..add(attachment);
    state = state.copyWith(newAttachments: updated);
    notifyListeners();
    return true;
  }

  void removeNewAttachmentAt(int index) {
    final updated = List<PatrimonyNewAttachment>.from(state.newAttachments)
      ..removeAt(index);
    state = state.copyWith(newAttachments: updated);
    notifyListeners();
  }

  void removeExistingAttachment(String attachmentId) {
    final updatedExisting = List<PatrimonyAttachmentModel>.from(
      state.existingAttachments,
    )..removeWhere((element) => element.attachmentId == attachmentId);
    final updatedRemove = Set<String>.from(state.attachmentsToRemove)
      ..add(attachmentId);

    state = state.copyWith(
      existingAttachments: updatedExisting,
      attachmentsToRemove: updatedRemove,
    );
    notifyListeners();
  }

  Future<bool> submit() async {
    state = state.copyWith(makeRequest: true);
    notifyListeners();

    try {
      final payload = state.toFormData(
        includeImmutableFields: !state.isEditing,
      );
      if (state.isEditing && state.assetId != null) {
        await service.updateAsset(state.assetId!, payload);
        state = state.copyWith(
          makeRequest: false,
          newAttachments: const [],
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
}
