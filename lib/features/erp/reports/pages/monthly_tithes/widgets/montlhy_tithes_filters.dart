import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:gloria_finance/features/erp/reports/pages/monthly_tithes/store/monthly_tithes_list_store.dart';
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
      label: context.l10n.common_year,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Permite solo números
        LengthLimitingTextInputFormatter(4), // Limita a 4 caracteres
      ],
      initialValue: tithesListStore.state.filter.year,
      onChanged: (value) {
        if (value.isNotEmpty) {
          tithesListStore.setYear(int.parse(value));
        }
      },
    );
  }

  Widget _dropdownMonth(
    BuildContext context,
    MonthlyTithesListStore tithesListStore,
  ) {
    return Dropdown(
      label: context.l10n.common_month,
      initialValue: tithesListStore.state.filter.month.toString().padLeft(
        2,
        '0',
      ),
      items:
          monthDropdown(context).map((item) => item.value.toString()).toList(),
      onChanged: (value) => tithesListStore.setMonth(int.parse(value)),
    );
  }

  Widget _layoutDesktop(
    BuildContext context,
    MonthlyTithesListStore tithesListStore,
  ) {
    return SizedBox(
      width: 820,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _dropdownMonth(context, tithesListStore)),
          const SizedBox(width: 20),
          Expanded(flex: 1, child: _inputYear(tithesListStore)),
          const SizedBox(width: 80),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 45),
              child: _buttonApplyFilter(tithesListStore),
            ),
          ),
        ],
      ),
    );
  }

  Widget _layoutMobile(
    BuildContext context,
    MonthlyTithesListStore tithesListStore,
  ) {
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
                context.l10n.common_filters_upper,
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
                        flex: 1,
                        child: _dropdownMonth(context, tithesListStore),
                      ),
                      const SizedBox(width: 20),
                      Expanded(flex: 1, child: _inputYear(tithesListStore)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buttonApplyFilter(tithesListStore),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonApplyFilter(MonthlyTithesListStore tithesListStore) {
    final l10n = context.l10n;
    return ButtonActionTable(
      color: AppColors.blue,
      text: l10n.common_apply_filters,
      icon: Icons.search,
      onPressed: () {
        if (isExpandedFilter) {
          setState(() {
            isExpandedFilter = false;
          });
        }
        tithesListStore.searchMonthlyTithes();
      },
    );
  }
}
