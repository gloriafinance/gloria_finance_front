import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/features/erp/reports/pages/monthly_tithes/store/monthly_tithes_list_store.dart';
import 'package:gloria_finance/features/erp/reports/pages/monthly_tithes/widgets/monthly_tithes_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/cards_summary_tithes.dart';
import 'widgets/montlhy_tithes_filters.dart';

class MonthlyTithesScreen extends StatelessWidget {
  const MonthlyTithesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => MonthlyTithesListStore()..searchMonthlyTithes(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildTitle(context), _buildContent()],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      context.l10n.reports_monthly_tithes_title,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<MonthlyTithesListStore>(
      builder: (context, store, _) {
        final isLoading = store.state.makeRequest;
        final data = store.state.data;
        final symbols = data.orderedSymbols;
        final hasManyCurrencies = symbols.length > 1;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MonthlyTithesFilters(),
                const SizedBox(height: 24),
                if (isLoading)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 80),
                    child: const CircularProgressIndicator(),
                  )
                else ...[
                  Text(
                    context.l10n.reports_monthly_tithes_section_title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 24,
                      color: Colors.black87,
                    ),
                  ),
                  if (hasManyCurrencies) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9ECEF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        context.l10n.reports_monthly_tithes_currency_badge(
                          symbols.join(', '),
                          symbols.length.toString(),
                        ),
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context
                          .l10n
                          .reports_monthly_tithes_multi_currency_disclaimer,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (data.results.isEmpty)
                    _buildEmptyState(context)
                  else ...[
                    const CardsSummaryTithes(),
                    const SizedBox(height: 24),
                    const MonthlyTithesTable(),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Text(
        context.l10n.reports_monthly_tithes_empty_selected_period,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: Colors.black45,
        ),
      ),
    );
  }
}
