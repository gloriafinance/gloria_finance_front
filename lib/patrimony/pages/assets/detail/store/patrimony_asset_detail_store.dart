import 'package:flutter/material.dart';

import '../../../../services/patrimony_service.dart';
import '../state/patrimony_asset_detail_state.dart';

class PatrimonyAssetDetailStore extends ChangeNotifier {
  PatrimonyAssetDetailState state = PatrimonyAssetDetailState.initial();
  final PatrimonyService service;

  PatrimonyAssetDetailStore({PatrimonyService? service})
      : service = service ?? PatrimonyService();

  Future<void> loadAsset(String assetId) async {
    state = state.copyWith(loading: true, hasError: false);
    notifyListeners();

    try {
      final asset = await service.getAsset(assetId);
      state = state.copyWith(loading: false, asset: asset);
    } catch (e) {
      state = state.copyWith(loading: false, hasError: true);
    }

    notifyListeners();
  }
}
