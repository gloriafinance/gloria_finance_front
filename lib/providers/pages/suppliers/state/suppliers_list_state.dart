import 'package:church_finance_bk/providers/models/supplier_model.dart';

class SuppliersListState {
  final List<SupplierModel> suppliers;
  final bool makeRequest;

  SuppliersListState({required this.suppliers, required this.makeRequest});

  factory SuppliersListState.empty() {
    return SuppliersListState(
      suppliers: [],
      makeRequest: false,
    );
  }

  SuppliersListState copyWith({
    List<SupplierModel>? suppliers,
    bool? makeRequest,
  }) {
    return SuppliersListState(
      suppliers: suppliers ?? this.suppliers,
      makeRequest: makeRequest ?? this.makeRequest,
    );
  }
}
