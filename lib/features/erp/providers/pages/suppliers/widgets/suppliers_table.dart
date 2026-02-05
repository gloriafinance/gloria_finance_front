import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/suppliers_list_store.dart';

class SuppliersTable extends StatefulWidget {
  const SuppliersTable({super.key});

  @override
  State<StatefulWidget> createState() => _SuppliersTable();
}

class _SuppliersTable extends State<SuppliersTable> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<SuppliersListStore>();

    final state = store.state;

    if (state.makeRequest) {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 40.0),
          child: CircularProgressIndicator());
    }

    return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: CustomTable(
          headers: ["Nome", "Telefone", "Email"],
          data: FactoryDataTable(
            data: state.suppliers,
            dataBuilder: suppliersDTO,
          ),
        ));
  }

  List<dynamic> suppliersDTO(dynamic supplier) {
    return [
      supplier.name,
      supplier.phone,
      supplier.email,
      // Row(
      //   children: [
      //     IconButton(
      //       icon: Icon(Icons.edit),
      //       onPressed: () {
      //         // Implement edit functionality
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.delete),
      //       onPressed: () {
      //         // Implement delete functionality
      //       },
      //     ),
      //   ],
      // ),
    ];
  }
}
