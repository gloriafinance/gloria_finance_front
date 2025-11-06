import 'dart:convert';

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/finance/bank_statements/models/bank_statement_model.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankStatementDetailView extends StatelessWidget {
  final BankStatementModel statement;

  const BankStatementDetailView({super.key, required this.statement});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _InfoTile(
                label: 'Banco',
                value: '${statement.bank.bankName} (${statement.bank.tag})',
              ),
              _InfoTile(
                label: 'Conta',
                value: statement.availabilityAccount.accountName,
              ),
              _InfoTile(
                label: 'Data de lançamento',
                value: dateFormat.format(statement.postedAt.toLocal()),
              ),
              _InfoTile(
                label: 'Valor',
                value: CurrencyFormatter.formatCurrency(statement.amount),
              ),
              _InfoTile(
                label: 'Direção',
                value: statement.direction.friendlyName,
              ),
              _InfoTile(
                label: 'Status',
                value: statement.reconciliationStatus.friendlyName,
                color: statement.reconciliationStatus.badgeColor,
              ),
              _InfoTile(
                label: 'Identificador FIT',
                value: statement.fitId ?? '-',
              ),
              _InfoTile(label: 'Hash', value: statement.hash ?? '-'),
              _InfoTile(
                label: 'Referência',
                value:
                    '${statement.month.toString().padLeft(2, '0')}/${statement.year}',
              ),
              _InfoTile(
                label: 'Criado em',
                value: dateFormat.format(statement.createdAt.toLocal()),
              ),
              _InfoTile(
                label: 'Atualizado em',
                value: dateFormat.format(statement.updatedAt.toLocal()),
              ),
              _InfoTile(
                label: 'Conciliado em',
                value:
                    statement.reconciledAt != null
                        ? dateFormat.format(statement.reconciledAt!.toLocal())
                        : '—',
              ),
              _InfoTile(
                label: 'Lançamento financeiro',
                value: statement.financialRecordId ?? 'Não vinculado',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Descrição',
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              color: AppColors.purple,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statement.description,
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
          if (statement.raw != null && statement.raw!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Dados brutos',
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: AppColors.purple,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.greyLight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                const JsonEncoder.withIndent('  ').convert(statement.raw),
                style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _InfoTile({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 200 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 15,
              color: color ?? AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
