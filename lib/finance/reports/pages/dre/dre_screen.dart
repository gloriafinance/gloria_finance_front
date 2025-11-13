// lib/finance/reports/pages/dre/dre_screen.dart

import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
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
      child: LayoutDashboard(_buildTitle(), screen: _buildContent()),
    );
  }

  Widget _buildTitle() {
    return Text(
      'DRE - Demonstração do Resultado do Exercício',
      textAlign: TextAlign.left,
      style: TextStyle(
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
                  _buildReportHeader(),
                  const SizedBox(height: 28),
                  DRECards(data: data),
                  const SizedBox(height: 40),
                  _buildReportInfo(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Text(
          'Demonstração do Resultado do Exercício',
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Relatório contábil que apresenta o resultado das operações em um período específico',
          style: TextStyle(
            fontFamily: AppFonts.fontBody,
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildReportInfo() {
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
              'Nota: Este relatório considera apenas lançamentos confirmados e reconciliados que afetam o resultado contábil.',
              style: TextStyle(
                fontFamily: AppFonts.fontBody,
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
