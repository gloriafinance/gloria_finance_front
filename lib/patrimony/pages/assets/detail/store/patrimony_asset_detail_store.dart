import 'package:flutter/material.dart';

import '../../../../models/patrimony_asset_model.dart';
import '../../../../services/patrimony_service.dart';

class PatrimonyAssetDetailStore extends ChangeNotifier {
  PatrimonyAssetModel asset;
  final PatrimonyService service;

  bool _registeringDisposal = false;
  bool _registeringInventory = false;

  PatrimonyAssetDetailStore({
    required this.asset,
    PatrimonyService? service,
  }) : service = service ?? PatrimonyService();

  bool get registeringDisposal => _registeringDisposal;

  bool get registeringInventory => _registeringInventory;

  Future<bool> registerDisposal({
    required String status,
    required String reason,
    String? disposedAt,
    String? observations,
  }) async {
    if (_registeringDisposal) {
      return false;
    }

    _registeringDisposal = true;
    notifyListeners();

    try {
      final updated = await service.registerDisposal(
        asset.assetId,
        status: status,
        reason: reason,
        disposedAt: disposedAt,
        observations: observations,
      );

      asset = updated;
      _registeringDisposal = false;
      notifyListeners();
      return true;
    } catch (_) {
      _registeringDisposal = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerInventory({
    required String status,
    String? checkedAt,
    String? notes,
    required String code,
    required int quantity,
  }) async {
    if (_registeringInventory) {
      return false;
    }

    _registeringInventory = true;
    notifyListeners();

    try {
      final updated = await service.registerInventory(
        asset.assetId,
        status: status,
        checkedAt: checkedAt,
        notes: notes,
        code: code,
        quantity: quantity,
      );

      asset = updated;
      _registeringInventory = false;
      notifyListeners();
      return true;
    } catch (_) {
      _registeringInventory = false;
      notifyListeners();
      return false;
    }
  }
}
