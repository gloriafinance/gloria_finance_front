import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FactoryDataTable<T> {
  final List<T> data;
  final List<dynamic> Function(dynamic) dataBuilder;

  FactoryDataTable({required this.data, required this.dataBuilder});
}

class CustomTable extends StatefulWidget {
  final List<dynamic> headers;

  //final List<List<String>> data;
  final FactoryDataTable data;
  final List<Widget Function(dynamic)>? actionBuilders;
  final PaginationData? paginate;
  final bool? showCheckbox;
  final Function(dynamic, bool)? onCheckboxChanged;
  final bool Function(dynamic)? isChecked;
  final double? dataRowMinHeight;
  final double? dataRowMaxHeight;

  const CustomTable({
    super.key,
    required this.headers,
    required this.data,
    this.actionBuilders,
    this.paginate,
    this.showCheckbox,
    this.onCheckboxChanged,
    this.isChecked,
    this.dataRowMinHeight,
    this.dataRowMaxHeight,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  int? perPageState;

  List<int> _perPageOptions() {
    final options = <int>{10, 20, 50, 70};
    if (perPageState != null) {
      options.add(perPageState!);
    }

    final sorted = options.toList()..sort();
    return sorted;
  }

  @override
  void initState() {
    super.initState();
    perPageState = widget.paginate?.perPage ?? 10;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 52.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),

            child:
                isMobile(context)
                    ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildDataTable(context),
                    )
                    : _buildDataTable(context),
          ),
        ),
        if (widget.paginate != null) _buildPaginate(context),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context) {
    return DataTable(
      dataRowMinHeight: widget.dataRowMinHeight,
      dataRowMaxHeight: widget.dataRowMaxHeight,
      headingRowColor: WidgetStateProperty.resolveWith(
        (states) => AppColors.greyLight,
      ),
      columns: [
        // Columna para checkbox si está habilitado
        if (widget.showCheckbox == true)
          const DataColumn(
            label: Text(
              "",
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: Colors.black87,
              ),
            ),
          ),
        ...widget.headers.map(
          (header) => DataColumn(
            label:
                header is String
                    ? Text(
                      header.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        color: Colors.black87,
                      ),
                    )
                    : header,
          ),
        ),
        if (widget.actionBuilders != null)
          DataColumn(
            label: Text(
              context.l10n.common_actions.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: Colors.black87,
              ),
            ),
          ),
      ],
      rows: List.generate(widget.data.data.length, (rowIndex) {
        final item = widget.data.data[rowIndex];

        final rowData = widget.data.dataBuilder(item);

        // Determinar si el checkbox está marcado
        final bool isItemChecked =
            widget.isChecked != null ? widget.isChecked!(item) : false;

        return DataRow(
          cells: [
            // Celda de checkbox si está habilitado
            if (widget.showCheckbox == true)
              DataCell(
                Checkbox(
                  value: isItemChecked,
                  onChanged: (value) {
                    if (widget.onCheckboxChanged != null && value != null) {
                      widget.onCheckboxChanged!(item, value);
                    }
                  },
                ),
              ),
            ...rowData.map(
              (cell) => DataCell(
                cell is String
                    ? Text(
                      cell,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        color: Colors.black54,
                      ),
                    )
                    : cell,
              ),
            ),
            if (widget.actionBuilders != null)
              DataCell(
                Row(
                  children:
                      widget.actionBuilders!
                          .map((actionBuilder) => actionBuilder(item))
                          .toList(),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildPaginate(BuildContext context) {
    if (widget.paginate == null) return SizedBox.shrink();

    int showRecords = widget.paginate!.currentPage * widget.paginate!.perPage;
    if (showRecords > widget.paginate!.totalRecords) {
      showRecords = widget.paginate!.totalRecords;
    }

    if (!isMobile(context)) {
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
            Expanded(
              child: Text(
                "Visualizando $showRecords de ${widget.paginate!.totalRecords} registros",
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.fontSubTitle,
                  color: Colors.black87,
                ),
              ),
            ),
            // Selector de registros por página y navegación
            _selectPerPage(),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Visualizando $showRecords de ${widget.paginate!.totalRecords} registros",
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppFonts.fontSubTitle,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          _selectPerPage(),
        ],
      ),
    );
  }

  Widget _selectPerPage() {
    if (widget.paginate == null) return SizedBox.shrink();

    if (!isMobile(context)) {
      return Row(
        children: [
          DropdownButton<int>(
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: Colors.black87,
            ),
            value: perPageState,
            items:
                _perPageOptions().map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value por página"),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  perPageState = value;
                });
                widget.paginate!.onChangePerPage(value);
              }
            },
          ),
          const SizedBox(width: 16),
          _prevButton(),
          const SizedBox(width: 8),
          _nextButton(),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButton<int>(
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: Colors.black87,
            ),
            value: perPageState,
            items:
                _perPageOptions().map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value por página"),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  perPageState = value;
                });
                widget.paginate!.onChangePerPage(value);
              }
            },
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_prevButton(), const SizedBox(width: 8), _nextButton()],
          ),
        ),
      ],
    );
  }

  Widget _nextButton() {
    return widget.paginate != null
        ? CustomButton(
          padding: EdgeInsets.symmetric(vertical: 4),
          text: "",
          icon: Icons.skip_next_outlined,
          backgroundColor:
              widget.paginate!.nextPag ? AppColors.green : AppColors.greyLight,
          onPressed:
              widget.paginate!.nextPag ? widget.paginate!.onNextPag : () {},
        )
        : SizedBox.shrink();
  }

  Widget _prevButton() {
    return widget.paginate != null
        ? CustomButton(
          padding: EdgeInsets.symmetric(vertical: 4),
          text: "",
          icon: Icons.skip_previous_outlined,
          backgroundColor:
              widget.paginate!.currentPage > 1
                  ? AppColors.green
                  : AppColors.greyLight,
          onPressed:
              widget.paginate!.currentPage > 1
                  ? widget.paginate!.onPrevPag
                  : () {},
        )
        : SizedBox.shrink();
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
