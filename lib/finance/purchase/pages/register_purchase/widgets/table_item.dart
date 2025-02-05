import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/purchase_register_form_state.dart';
import '../../../store/purchase_register_form_store.dart';

class TableItem extends StatelessWidget {
  const TableItem({super.key});

  @override
  Widget build(BuildContext context) {
    final formPurchase = Provider.of<PurchaseRegisterFormStore>(context);
    final state = formPurchase.state;

    return CustomTable(
      headers: ["Produto", "Preço", "Quantidade", "Total"],
      data: FactoryDataTable<PurchaseItem>(
          data: state.items, dataBuilder: itemDTO),
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
