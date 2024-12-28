import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/providers/contributions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/contribution.helper.dart';
import '../../models/contribution_model.dart';

class ViewContribution extends ConsumerWidget {
  final Contribution contribution;

  const ViewContribution({super.key, required this.contribution});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              _buildDetailRow(
                  'Tipo', contribution.type.toString().split('.').last),
              const SizedBox(height: 16),
              _buildSectionTitle('Recibo de Transferência'),
              Text(
                contribution.bankTransferReceipt,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
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
              if (parseContributionStatus(contribution.status) ==
                  ContributionStatus.PENDING_VERIFICATION)
                _buildButton(context, ref, contribution.contributionId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, WidgetRef ref, String contributionId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ButtonActionTable(
          color: AppColors.green,
          text: 'Aprovar',
          onPressed: () async {
            await updateContributionStatus(
                contributionId, ContributionStatus.PROCESSED);
            ref.read(contributionsFilterProvider.notifier).refresh();
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

            ref.read(contributionsFilterProvider.notifier).refresh();

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
