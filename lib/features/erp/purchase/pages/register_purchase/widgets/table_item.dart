import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:flutter/material.dart';

import '../state/purchase_register_form_state.dart';

class TableItem extends StatelessWidget {
  final List<PurchaseItem> items;

  const TableItem({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      headers: ["Produto", "Preço", "Quantidade", "Total"],
      data: FactoryDataTable<PurchaseItem>(data: items, dataBuilder: itemDTO),
    );
  }

  List<dynamic> itemDTO(dynamic item) {
    return [
      item.productName.toString(),
      item.priceUnit.toString(),
      item.quantity.toString(),
      item.total.toString(),
    ];
  }
}
