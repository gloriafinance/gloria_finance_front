import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/helpers/contribution.helper.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:flutter/material.dart';

import '../../usecases/update_contribution_status.dart';
import 'content_viewer.dart';

class ViewContribution extends StatelessWidget {
  final ContributionModel contribution;

  const ViewContribution({super.key, required this.contribution});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(),
              const Divider(),
              SizedBox(height: 16),
              _buildDetailRow(
                  'Valor', 'R\$ ${contribution.amount.toStringAsFixed(2)}'),
              _buildDetailRow(
                'Status',
                parseContributionStatus(contribution.status).friendlyName,
                statusColor: getStatusColor(
                    parseContributionStatus(contribution.status)),
              ),
              _buildDetailRow(
                'Data',
                '${contribution.createdAt.day}/${contribution.createdAt.month}/${contribution.createdAt.year}',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Membro'),
              Text(
                '${contribution.member.name} (ID: ${contribution.member.memberId})',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Conceito Financeiro'),
              Text(
                contribution.financeConcept.name,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 26),
              _buildSectionTitle('Recibo de Transferência'),
              const SizedBox(height: 26),
              ContentViewer(url: contribution.bankTransferReceipt),
              const SizedBox(height: 46),
              if (parseContributionStatus(contribution.status) ==
                  ContributionStatus.PENDING_VERIFICATION)
                _buildButton(context, contribution.contributionId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String contributionId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ButtonActionTable(
          color: AppColors.blue,
          text: 'Aprovar',
          onPressed: () async {
            await updateContributionStatus(
                contributionId, ContributionStatus.PROCESSED);

            Navigator.of(context).pop();
          },
          icon: Icons.check,
        ),
        ButtonActionTable(
          color: Colors.red,
          text: "Rejeitar",
          onPressed: () async {
            print("Rechazar fila $contribution");
            await updateContributionStatus(
                contributionId, ContributionStatus.REJECTED);

            Navigator.of(context).pop();
          },
          icon: Icons.cancel,
        )
      ],
    );
  }

  Widget _buildTitleSection() {
    return Center(
      child: Text(
        'Contribuição #${contribution.contributionId}',
        style: const TextStyle(
          fontSize: 18,
          fontFamily: AppFonts.fontMedium,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                const TextStyle(fontSize: 16, fontFamily: AppFonts.fontRegular),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppFonts.fontLight,
              color: statusColor, // Aplica el color aquí
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.purple,
      ),
    );
  }
}
