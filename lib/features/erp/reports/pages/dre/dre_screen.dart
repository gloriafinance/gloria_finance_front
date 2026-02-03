// lib/finance/reports/pages/dre/dre_screen.dart

import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/dre_model.dart';
import 'store/dre_store.dart';
import 'widgets/dre_cards.dart';
import 'widgets/dre_filters.dart';

class DREScreen extends StatelessWidget {
  const DREScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => DREStore()..fetchDRE(),
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTitle(context), _buildContent()],
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      context.l10n.reports_dre_screen_title,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<DREStore>(
      builder: (context, store, _) {
        final isLoading = store.state.makeRequest;
        final data = store.state.data;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DREFilters(),
                const SizedBox(height: 24),
                if (isLoading)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 80),
                    child: const CircularProgressIndicator(),
                  )
                else ...[
                  _buildReportHeader(context, data),
                  const SizedBox(height: 28),
                  if (!data.hasData)
                    _buildEmptyState(context)
                  else
                    DRECards(data: data),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportHeader(BuildContext context, DREReportModel data) {
    final symbols = data.orderedSymbols;
    final hasManyCurrencies = symbols.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Text(
          context.l10n.reports_dre_header_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        if (hasManyCurrencies) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9ECEF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              context.l10n.reports_dre_currency_badge(
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
            context.l10n.reports_dre_multi_currency_disclaimer,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ] else ...[
          const SizedBox(height: 8),
          Text(
            context.l10n.reports_dre_header_subtitle,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
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
        context.l10n.reports_dre_empty_selected_period,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: Colors.black45,
        ),
      ),
    );
  }
}
