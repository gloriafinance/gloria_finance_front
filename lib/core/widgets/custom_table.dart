import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> data;
  final List<Widget Function(int rowIndex)>? actionBuilders;

  const CustomTable({
    super.key,
    required this.headers,
    required this.data,
    this.actionBuilders, // Parámetro opcional para las acciones
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 52.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Habilita el scroll horizontal
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith(
                (states) => Colors.grey.shade200,
              ),
              columns: [
                ...headers.map(
                  (header) => DataColumn(
                    label: Expanded(
                      child: Text(
                        header.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontMedium,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                if (actionBuilders !=
                    null) // Solo agrega la columna de acciones si hay acciones
                  const DataColumn(
                    label: Text(
                      "AÇÕES",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.fontMedium,
                        color: Colors.black87,
                      ),
                    ),
                  ),
              ],
              rows: List.generate(
                data.length,
                (rowIndex) {
                  final rowData = data[rowIndex];
                  return DataRow(
                    cells: [
                      ...rowData.map(
                        (cell) => DataCell(
                          Center(
                            child: Text(
                              cell,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: AppFonts.fontRegular,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (actionBuilders != null)
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: actionBuilders!
                                .map((actionBuilder) => actionBuilder(rowIndex))
                                .toList(),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
