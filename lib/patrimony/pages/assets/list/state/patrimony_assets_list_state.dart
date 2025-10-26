import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_model.dart';

class PatrimonyAssetsListState {
  final bool loading;
  final bool hasError;
  final PaginateResponse<PatrimonyAssetModel> assets;
  final int page;
  final int perPage;
  final String search;
  final String? status;
  final String? category;

  PatrimonyAssetsListState({
    required this.loading,
    required this.hasError,
    required this.assets,
    required this.page,
    required this.perPage,
    required this.search,
    this.status,
    this.category,
  });

  factory PatrimonyAssetsListState.initial() {
    return PatrimonyAssetsListState(
      loading: false,
      hasError: false,
      assets: PaginateResponse.init(),
      page: 1,
      perPage: 20,
      search: '',
    );
  }

  PatrimonyAssetsListState copyWith({
    bool? loading,
    bool? hasError,
    PaginateResponse<PatrimonyAssetModel>? assets,
    int? page,
    int? perPage,
    String? search,
    String? status,
    bool clearStatus = false,
    String? category,
    bool clearCategory = false,
  }) {
    return PatrimonyAssetsListState(
      loading: loading ?? this.loading,
      hasError: hasError ?? this.hasError,
      assets: assets ?? this.assets,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      status: clearStatus ? null : (status ?? this.status),
      category: clearCategory ? null : (category ?? this.category),
    );
  }
}
