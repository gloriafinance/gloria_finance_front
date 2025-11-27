import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../store/financial_month_store.dart';

class FinancialMonthFilters extends StatefulWidget {
  const FinancialMonthFilters({super.key});

  @override
  State<FinancialMonthFilters> createState() => _FinancialMonthFiltersState();
}

class _FinancialMonthFiltersState extends State<FinancialMonthFilters> {
  bool _isExpandedFilter = false;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinancialMonthStore>(
      builder: (context, store, _) {
        _selectedYear = store.state.selectedYear;
        return isMobile(context) ? _mobileLayout(store) : _desktopLayout(store);
      },
    );
  }

  Widget _mobileLayout(FinancialMonthStore store) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          setState(() {
            _isExpandedFilter = !_isExpandedFilter;
          });
        },
        animationDuration: const Duration(milliseconds: 500),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _isExpandedFilter,
            headerBuilder: (context, isOpen) {
              return const ListTile(
                title: Text(
                  'FILTROS',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                  ),
                ),
              );
            },
            body: Column(
              children: [
                Row(children: [Expanded(child: _yearInput(store))]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _clearButton(store)),
                    const SizedBox(width: 12),
                    Expanded(child: _applyButton(store)),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopLayout(FinancialMonthStore store) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 300, child: _yearInput(store)),
              const SizedBox(width: 16),
              Container(
                margin: const EdgeInsets.only(top: 48),
                child: _applyButton(store),
              ),
              const SizedBox(width: 12),
              Container(
                margin: const EdgeInsets.only(top: 48),
                child: _clearButton(store),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _yearInput(FinancialMonthStore store) {
    return Input(
      label: 'Ano',
      initialValue: _selectedYear?.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _selectedYear = int.tryParse(value);
          });
        }
      },
    );
  }

  Widget _applyButton(FinancialMonthStore store) {
    return ButtonActionTable(
      color: AppColors.blue,
      text: 'Aplicar filtros',
      icon: Icons.search,
      onPressed: () {
        if (_selectedYear != null) {
          setState(() {
            _isExpandedFilter = false;
          });
          store.setYear(_selectedYear!);
        }
      },
    );
  }

  Widget _clearButton(FinancialMonthStore store) {
    return ButtonActionTable(
      icon: Icons.clear,
      color: AppColors.mustard,
      text: 'Limpar filtros',
      onPressed: () {
        setState(() {
          _selectedYear = DateTime.now().year;
          _isExpandedFilter = false;
        });
        store.setYear(DateTime.now().year);
      },
    );
  }
}
