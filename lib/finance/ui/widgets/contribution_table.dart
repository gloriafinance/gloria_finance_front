import 'package:church_finance_bk/core/widgets/custom_table.dart';
import 'package:flutter/material.dart';

class ContributionTable extends StatefulWidget {
  const ContributionTable({super.key});

  @override
  State<ContributionTable> createState() => _ContributionTableState();
}

class _ContributionTableState extends State<ContributionTable> {
  @override
  Widget build(BuildContext context) {
    return CustomTable(
      headers: ["ID", "Nombre", "Monto", "Fecha"],
      data: [
        ["1", "Juan Pérez", "\$200.00", "2024-12-01"],
        ["2", "María López", "\$350.00", "2024-12-02"],
        ["3", "Carlos Gómez", "\$150.00", "2024-12-03"],
      ],
      actionBuilders: [
        (rowIndex) => IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                print("Editar fila $rowIndex");
              },
            ),
        (rowIndex) => IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                print("Eliminar fila $rowIndex");
              },
            ),
      ],
    );
  }
}
