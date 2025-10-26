import '../../../../models/patrimony_asset_model.dart';

class PatrimonyAssetDetailState {
  final bool loading;
  final PatrimonyAssetModel? asset;
  final bool hasError;

  PatrimonyAssetDetailState({
    required this.loading,
    required this.asset,
    required this.hasError,
  });

  factory PatrimonyAssetDetailState.initial() {
    return PatrimonyAssetDetailState(
      loading: true,
      asset: null,
      hasError: false,
    );
  }

  PatrimonyAssetDetailState copyWith({
    bool? loading,
    PatrimonyAssetModel? asset,
    bool? hasError,
  }) {
    return PatrimonyAssetDetailState(
      loading: loading ?? this.loading,
      asset: asset ?? this.asset,
      hasError: hasError ?? this.hasError,
    );
  }
}
