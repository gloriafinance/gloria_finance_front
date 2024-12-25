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
    this.actionBuilders,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600; // Detecta móvil

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
          child: isMobile
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: buildDataTable(context, isMobile),
                )
              : buildDataTable(context, isMobile),
        ),
      ],
    );
  }

  Widget buildDataTable(BuildContext context, bool isMobile) {
    return DataTable(
      headingRowColor: MaterialStateProperty.resolveWith(
        (states) => Colors.grey.shade200,
      ),
      columns: [
        ...headers.map(
          (header) => DataColumn(
            label: Text(
              header.toUpperCase(),
              style: const TextStyle(
                fontFamily: AppFonts.fontMedium,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        if (actionBuilders != null)
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
                  Text(
                    cell,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontRegular,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              if (actionBuilders != null)
                DataCell(
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: actionBuilders!
                        .map((actionBuilder) => actionBuilder(rowIndex))
                        .toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
