// lib/finance/reports/pages/dre/widgets/dre_filters.dart

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../store/dre_store.dart';

class DREFilters extends StatefulWidget {
  const DREFilters({super.key});

  @override
  State<DREFilters> createState() => _DREFiltersState();
}

class _DREFiltersState extends State<DREFilters> {
  bool isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<DREStore>(context);

    return isMobile(context)
        ? _layoutMobile(context, store)
        : _layoutDesktop(context, store);
  }

  Widget _inputYear(DREStore store) {
    return Input(
      label: context.l10n.common_year,
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

  Widget _dropdownMonth(BuildContext context, DREStore store) {
    return Dropdown(
      label: context.l10n.common_month,
      initialValue: (store.state.filter.month ?? DateTime.now().month)
          .toString()
          .padLeft(2, '0'),
      items:
          [
            {'label': '01', 'value': '01'},
            {'label': '02', 'value': '02'},
            {'label': '03', 'value': '03'},
            {'label': '04', 'value': '04'},
            {'label': '05', 'value': '05'},
            {'label': '06', 'value': '06'},
            {'label': '07', 'value': '07'},
            {'label': '08', 'value': '08'},
            {'label': '09', 'value': '09'},
            {'label': '10', 'value': '10'},
            {'label': '11', 'value': '11'},
            {'label': '12', 'value': '12'},
          ].map((item) => item['value'].toString()).toList(),
      onChanged: (value) => store.setMonth(int.parse(value)),
    );
  }

  Widget _layoutDesktop(BuildContext context, DREStore store) {
    return SizedBox(
      width: 820,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _dropdownMonth(context, store)),
          const SizedBox(width: 20),
          Expanded(flex: 1, child: _inputYear(store)),
          const SizedBox(width: 80),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 45),
              child: _buttonApplyFilter(store),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 45),
              child: _buttonDownloadPdf(store),
            ),
          ),
        ],
      ),
    );
  }

  Widget _layoutMobile(BuildContext context, DREStore store) {
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
                      Expanded(flex: 1, child: _dropdownMonth(context, store)),
                      const SizedBox(width: 20),
                      Expanded(flex: 1, child: _inputYear(store)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buttonApplyFilter(store),
                  const SizedBox(height: 12),
                  _buttonDownloadPdf(store),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonApplyFilter(DREStore store) {
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
        store.fetchDRE();
      },
    );
  }

  Widget _buttonDownloadPdf(DREStore store) {
    final isLoading = store.state.downloadingPdf;

    return Stack(
      alignment: Alignment.center,
      children: [
        CustomButton(
          text: context.l10n.reports_dre_download_pdf,
          backgroundColor: AppColors.blue,
          textColor: Colors.white,
          icon: Icons.picture_as_pdf,
          padding: EdgeInsets.only(top: 8, bottom: 8),
          onPressed:
              isLoading
                  ? null
                  : () async {
                    if (isExpandedFilter) {
                      setState(() {
                        isExpandedFilter = false;
                      });
                    }

                    await store.downloadDREPdf(context);
                  },
        ),

        if (isLoading)
          const Positioned(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
}
