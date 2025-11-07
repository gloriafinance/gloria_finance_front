import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/bank_statements/models/bank_statement_model.dart';
import 'package:church_finance_bk/finance/bank_statements/store/bank_statement_import_store.dart';
import 'package:church_finance_bk/finance/bank_statements/store/bank_statement_list_store.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/bank_statement_filters.dart';
import 'widgets/bank_statement_import_sheet.dart';
import 'widgets/bank_statement_table.dart';

class BankStatementsScreen extends StatelessWidget {
  const BankStatementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BankStore()..searchBanks()),
        ChangeNotifierProvider(
          create: (_) => BankStatementListStore()..fetchStatements(),
        ),
      ],
      child: MaterialApp(home: LayoutDashboard(_Header(), screen: _Body())),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<BankStatementListStore>();
    final statements = store.state.statements;

    final pending =
        statements
            .where(
              (item) =>
                  item.reconciliationStatus ==
                  BankStatementReconciliationStatus.pending,
            )
            .length;
    final unmatched =
        statements
            .where(
              (item) =>
                  item.reconciliationStatus ==
                  BankStatementReconciliationStatus.unmatched,
            )
            .length;
    final reconciled =
        statements
            .where(
              (item) =>
                  item.reconciliationStatus ==
                  BankStatementReconciliationStatus.reconciled,
            )
            .length;

    return isMobile(context)
        ? _mobileHeader(context, pending, unmatched, reconciled)
        : _desktopHeader(context, pending, unmatched, reconciled);
  }

  Widget _desktopHeader(
    BuildContext context,
    int pending,
    int unmatched,
    int reconciled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Conciliação bancária',
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 22,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ButtonActionTable(
              color: AppColors.blue,
              text: 'Importar extrato',
              icon: Icons.cloud_upload_outlined,
              onPressed: () => _openImportSheet(context),
            ),
            const SizedBox(width: 8),
            ButtonActionTable(
              color: AppColors.purple,
              text: 'Atualizar',
              icon: Icons.refresh_outlined,
              onPressed:
                  () =>
                      context.read<BankStatementListStore>().fetchStatements(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _StatusOverview(
          pending: pending,
          unmatched: unmatched,
          reconciled: reconciled,
        ),
      ],
    );
  }

  Widget _mobileHeader(
    BuildContext context,
    int pending,
    int unmatched,
    int reconciled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conciliação bancária',
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 22,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ButtonActionTable(
                color: AppColors.blue,
                text: 'Importar',
                icon: Icons.cloud_upload_outlined,
                onPressed: () => _openImportSheet(context),
              ),
            ),
            Expanded(
              child: ButtonActionTable(
                color: AppColors.purple,
                text: 'Atualizar',
                icon: Icons.refresh_outlined,
                onPressed:
                    () =>
                        context
                            .read<BankStatementListStore>()
                            .fetchStatements(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _StatusOverview(
          pending: pending,
          unmatched: unmatched,
          reconciled: reconciled,
        ),
      ],
    );
  }

  void _openImportSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder:
          (_) => ChangeNotifierProvider(
            create: (_) => BankStatementImportStore(),
            child: const BankStatementImportSheet(),
          ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BankStatementFilters(),
        const SizedBox(height: 24), BankStatementTable(),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: SingleChildScrollView(child: const BankStatementTable()),
        // ),
      ],
    );
  }
}

class _StatusOverview extends StatelessWidget {
  final int pending;
  final int unmatched;
  final int reconciled;

  const _StatusOverview({
    required this.pending,
    required this.unmatched,
    required this.reconciled,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _StatusCard(
          label: 'Pendentes',
          value: pending,
          color: AppColors.mustard,
        ),
        _StatusCard(
          label: 'Não conciliados',
          value: unmatched,
          color: Colors.redAccent,
        ),
        _StatusCard(
          label: 'Conciliados',
          value: reconciled,
          color: AppColors.green,
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatusCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobile(context) ? double.infinity : 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        color: color.withOpacity(0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 26,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
