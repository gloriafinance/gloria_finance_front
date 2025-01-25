import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/finance/financial_records/models/finance_record_list_model.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

import '../../../../../settings/financial_concept/models/financial_concept_model.dart';
import '../../../../widgets/content_viewer.dart';

class ViewFinanceRecord extends StatelessWidget {
  final FinanceRecordListModel financeRecord;

  const ViewFinanceRecord({super.key, required this.financeRecord});

  @override
  Widget build(BuildContext context) {
    bool mobile = isMobile(context);
    return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildTitleSection(),
              const Divider(),
              const SizedBox(height: 16),
              _buildSectionTitle('Conceito Financeiro'),
              Text(
                financeRecord.financialConcept.name,
                style: const TextStyle(
                    fontSize: 16, fontFamily: AppFonts.fontLight),
              ),
              SizedBox(height: 16),
              _buildDetailRow(mobile, 'Valor',
                  'R\$ ${financeRecord.amount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildDetailRow(
                mobile,
                'Data',
                '${financeRecord.date.day}/${financeRecord.date.month}/${financeRecord.date.year}',
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                mobile,
                'Tipo de movimento',
                getFriendlyNameFinancialConceptType(financeRecord.type),
              ),
              if (financeRecord.costCenter != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow(
                  mobile,
                  'Centro de custo',
                  financeRecord.costCenter!.name,
                ),
              ],
              const SizedBox(height: 8),
              _buildDetailRow(
                mobile,
                'Conta de disponibilidade',
                financeRecord.availabilityAccount.accountName,
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                mobile,
                'Descrição',
                financeRecord.description,
              ),
              if (financeRecord.voucher != null) ...[
                const SizedBox(height: 26),
                ContentViewer(url: financeRecord.voucher!),
              ],
            ])));
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: AppFonts.fontMedium,
        color: AppColors.purple,
      ),
    );
  }

  Widget _buildDetailRow(bool isMobile, String title, String value,
      {Color? statusColor}) {
    return isMobile
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontFamily: AppFonts.fontMedium),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppFonts.fontLight,
                      color: statusColor, // Aplica el color aquí
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // Añade esto
                  ),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 6,
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontFamily: AppFonts.fontMedium),
                    )),
                Expanded(
                  flex: 6,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppFonts.fontLight,
                      color: statusColor, // Aplica el color aquí
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // Añade esto
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildTitleSection() {
    return Center(
      child: Text(
        'Movimento financeiro #${financeRecord.financialRecordId}',
        style: const TextStyle(
          fontSize: 18,
          fontFamily: AppFonts.fontMedium,
        ),
      ),
    );
  }
}
