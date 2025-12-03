// lib/finance/reports/pages/dre/dre_screen.dart

import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  _buildReportHeader(context),
                  const SizedBox(height: 28),
                  DRECards(data: data),
                  const SizedBox(height: 40),
                  _buildReportInfo(context),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportHeader(BuildContext context) {
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
    );
  }

  Widget _buildReportInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.reports_dre_footer_note,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 13,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
