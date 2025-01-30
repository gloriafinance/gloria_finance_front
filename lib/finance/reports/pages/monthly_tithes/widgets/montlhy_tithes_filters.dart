import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/finance/contributions/pages/app_contribuitions/widgets/month_dropdown.dart';
import 'package:church_finance_bk/finance/reports/pages/monthly_tithes/store/monthly_tithes_list_store.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MonthlyTithesFilters extends StatefulWidget {
  const MonthlyTithesFilters({super.key});

  @override
  State<MonthlyTithesFilters> createState() => _MonthlyTithesFiltersState();
}

class _MonthlyTithesFiltersState extends State<MonthlyTithesFilters> {
  bool isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final tithesListStore = Provider.of<MonthlyTithesListStore>(context);

    return isMobile(context)
        ? _layoutMobile(context, tithesListStore)
        : _layoutDesktop(context, tithesListStore);
  }

  Widget _inputYear(MonthlyTithesListStore tithesListStore) {
    return Input(
      label: 'Ano',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Permite solo números
        LengthLimitingTextInputFormatter(4), // Limita a 4 caracteres
      ],
      initialValue: tithesListStore.state.filter.year,
      onChanged: (value) => tithesListStore.setYear(int.parse(value)),
    );
  }

  Widget _dropdownMonth(
      BuildContext context, MonthlyTithesListStore tithesListStore) {
    return Dropdown(
      label: "Mês",
      items:
          monthDropdown(context).map((item) => item.value.toString()).toList(),
      onChanged: (value) => tithesListStore.setMonth(int.parse(value)),
    );
  }

  Widget _layoutDesktop(
      BuildContext context, MonthlyTithesListStore tithesListStore) {
    return SizedBox(
      //width: isMobile(context) ? MediaQuery.of(context).size.width : 300,
      width: 700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _dropdownMonth(context, tithesListStore)),
          SizedBox(
            width: 20,
          ),
          Expanded(flex: 1, child: _inputYear(tithesListStore)),
          SizedBox(
            width: 80,
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 45),
                child: _buttonApplyFilter(tithesListStore),
              )),
        ],
      ),
    );
  }

  Widget _layoutMobile(
      BuildContext context, MonthlyTithesListStore tithesListStore) {
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
                  //width: isMobile(context) ? MediaQuery.of(context).size.width : 300,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: _dropdownMonth(context, tithesListStore)),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(flex: 1, child: _inputYear(tithesListStore)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buttonApplyFilter(tithesListStore),
                    ],
                  )),
            ))
      ],
    );
  }

  Widget _buttonApplyFilter(MonthlyTithesListStore tithesListStore) {
    return CustomButton(
      text: "Filtrar",
      backgroundColor: AppColors.purple,
      textColor: Colors.white,
      onPressed: () => tithesListStore.searchMonthlyTithes(),
    );
  }
}
