import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class FactoryDataTable<T> {
  final List<T> data;
  final List<dynamic> Function(dynamic) dataBuilder;

  FactoryDataTable({
    required this.data,
    required this.dataBuilder,
  });
}

class CustomTable extends StatefulWidget {
  final List<String> headers;

  //final List<List<String>> data;
  final FactoryDataTable data;
  final List<Widget Function(dynamic)>? actionBuilders;
  final PaginationData paginate;

  const CustomTable({
    super.key,
    required this.headers,
    required this.data,
    this.actionBuilders,
    required this.paginate,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  int perPageState = 10;

  @override
  void initState() {
    super.initState();

    perPageState = widget.paginate.perPage;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600; // Detecta móvil

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight:
                MediaQuery.of(context).size.height * 0.8, // Limitar la altura
          ),
          width: MediaQuery.of(context).size.width,
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
        buildPaginate(),
      ],
    );
  }

  Widget buildDataTable(BuildContext context, bool isMobile) {
    return DataTable(
      headingRowColor: WidgetStateProperty.resolveWith(
        (states) => AppColors.greyLight,
      ),
      columns: [
        ...widget.headers.map(
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
        if (widget.actionBuilders != null)
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
        widget.data.data.length,
        (rowIndex) {
          final item = widget.data.data[rowIndex];

          final rowData = widget.data.dataBuilder(item);

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
              if (widget.actionBuilders != null)
                DataCell(
                  Row(
                    children: widget.actionBuilders!
                        .map((actionBuilder) => actionBuilder(item))
                        .toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPaginate() {
    int showRecords = widget.paginate.currentPage * widget.paginate.perPage;

    if (showRecords > widget.paginate.totalRecords) {
      showRecords = widget.paginate.totalRecords;
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Información de los registros
          Expanded(
            child: Text(
              "Mostrando $showRecords de ${widget.paginate.totalRecords} registros",
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.fontRegular,
                color: Colors.black87,
              ),
            ),
          ),
          // Selector de registros por página y navegación
          selectPerPage(),
        ],
      ),
    );
  }

  Widget selectPerPage() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            // Alineación del DropdownButton
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // Reducir padding interno
            child: DropdownButton<int>(
              value: perPageState,
              dropdownColor: Colors.white,
              underline: const SizedBox(),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.fontRegular,
                color: Colors.black87,
              ),
              isDense: true,
              // Reducir altura predeterminada del DropdownButton
              items: [10, 20, 50].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value por página"),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  perPageState = value;
                  widget.paginate.onChangePerPage(value);
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        prevButton(),
        const SizedBox(width: 8),
        nextButton(),
      ],
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () => widget.paginate.onNextPag(),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            widget.paginate.nextPag ? AppColors.purple : Colors.grey.shade300,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text("Próxima",
          style: TextStyle(fontSize: 14, fontFamily: AppFonts.fontLight)),
    );
  }

  Widget prevButton() {
    return ElevatedButton(
      onPressed: () => widget.paginate.onPrevPag(),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.paginate.currentPage > 1
            ? AppColors.purple
            : Colors.grey.shade300,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text("Anterior",
          style: TextStyle(fontSize: 14, fontFamily: AppFonts.fontLight)),
    );
  }
}

class PaginationData {
  final int totalRecords;
  final bool nextPag;
  final int perPage;
  final int currentPage;
  final void Function() onNextPag;
  final void Function() onPrevPag;
  final void Function(int) onChangePerPage;

  PaginationData({
    required this.totalRecords,
    required this.nextPag,
    required this.perPage,
    required this.currentPage,
    required this.onNextPag,
    required this.onPrevPag,
    required this.onChangePerPage,
  });

  toMap() {
    return {
      'totalRecords': totalRecords,
      'nextPag': nextPag,
      'perPage': perPage,
      'currentPage': currentPage,
    };
  }
}
