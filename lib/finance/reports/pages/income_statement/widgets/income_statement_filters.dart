import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/finance/contributions/pages/app_contribuitions/widgets/month_dropdown.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../store/income_statement_store.dart';

class IncomeStatementFilters extends StatefulWidget {
  const IncomeStatementFilters({super.key});

  @override
  State<IncomeStatementFilters> createState() => _IncomeStatementFiltersState();
}

class _IncomeStatementFiltersState extends State<IncomeStatementFilters> {
  bool isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<IncomeStatementStore>(context);

    return isMobile(context)
        ? _layoutMobile(context, store)
        : _layoutDesktop(context, store);
  }

  Widget _inputYear(IncomeStatementStore store) {
    return Input(
      label: 'Ano',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      initialValue: store.state.filter.year.toString(),
      onChanged: (value) {
        if (value.isNotEmpty) {
          store.setYear(int.parse(value));
        }
      },
    );
  }

  Widget _dropdownMonth(BuildContext context, IncomeStatementStore store) {
    return Dropdown(
      label: "Mês",
      initialValue: store.state.filter.month.toString().padLeft(2, '0'),
      items:
          monthDropdown(context).map((item) => item.value.toString()).toList(),
      onChanged: (value) => store.setMonth(int.parse(value)),
    );
  }

  Widget _layoutDesktop(BuildContext context, IncomeStatementStore store) {
    return SizedBox(
      width: 700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _dropdownMonth(context, store)),
          SizedBox(
            width: 20,
          ),
          Expanded(flex: 1, child: _inputYear(store)),
          SizedBox(
            width: 80,
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 45),
                child: _buttonApplyFilter(store),
              )),
        ],
      ),
    );
  }

  Widget _layoutMobile(BuildContext context, IncomeStatementStore store) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        isExpandedFilter = isExpanded;
        setState(() {});
      },
      animationDuration: const Duration(milliseconds: 500),
      children: [
        ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: isExpandedFilter,
            headerBuilder: (context, isOpen) {
              return ListTile(
                title: Text(
                  "FILTROS",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1, child: _dropdownMonth(context, store)),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(flex: 1, child: _inputYear(store)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buttonApplyFilter(store),
                    ],
                  )),
            ))
      ],
    );
  }

  Widget _buttonApplyFilter(IncomeStatementStore store) {
    return CustomButton(
      text: "Filtrar",
      backgroundColor: AppColors.purple,
      textColor: Colors.white,
      onPressed: () {
        if (isExpandedFilter) {
          setState(() {
            isExpandedFilter = false;
          });
        }
        store.fetchIncomeStatement();
      },
    );
  }
}
