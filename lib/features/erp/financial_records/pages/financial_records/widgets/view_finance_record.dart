import 'package:church_finance_bk/core/layout/view_detail_widgets.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/erp/financial_records/models/finance_record_list_model.dart';
import 'package:flutter/material.dart';

import '../../../../settings/financial_concept/models/financial_concept_model.dart';
import '../../../../widgets/content_viewer.dart';

class ViewFinanceRecord extends StatelessWidget {
  final FinanceRecordListModel financeRecord;

  const ViewFinanceRecord({super.key, required this.financeRecord});

  @override
  Widget build(BuildContext context) {
    bool mobile = isMobile(context);
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Identificador:",
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.fontTitle,
              ),
            ),
            SelectableText(
              financeRecord.financialRecordId,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.fontText,
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),

            _buildSectionTitle('Conceito Financeiro'),
            Text(
              financeRecord.financialConcept?.name ?? 'N/A',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.fontText,
              ),
            ),
            SizedBox(height: 16),
            buildDetailRow(
              mobile,
              'Valor',
              'R\$ ${financeRecord.amount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            buildDetailRow(
              mobile,
              'Data',
              '${financeRecord.date.day}/${financeRecord.date.month}/${financeRecord.date.year}',
            ),
            const SizedBox(height: 8),
            buildDetailRow(
              mobile,
              'Tipo de movimento',
              getFriendlyNameFinancialConceptType(financeRecord.type),
            ),
            if (financeRecord.costCenter != null) ...[
              const SizedBox(height: 8),
              buildDetailRow(
                mobile,
                'Centro de custo',
                financeRecord.costCenter!.name,
              ),
            ],
            const SizedBox(height: 8),
            buildDetailRow(
              mobile,
              'Conta de disponibilidade',
              financeRecord.availabilityAccount.accountName,
            ),
            const SizedBox(height: 8),
            buildDetailRow(
              mobile,
              'Descrição',
              financeRecord.description ?? "",
            ),
            if (financeRecord.voucher != null) ...[
              const SizedBox(height: 26),
              ContentViewer(url: financeRecord.voucher!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: AppFonts.fontTitle,
        color: AppColors.purple,
      ),
    );
  }
}
