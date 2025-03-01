import 'package:church_finance_bk/auth/pages/login/store/auth_session_store.dart';
import 'package:church_finance_bk/core/layout/view_detail_widgets.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/contributions/models/contribution_model.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/content_viewer.dart';
import '../../../helpers/contribution.helper.dart';
import '../../../store/contribution_pagination_store.dart';

class ViewContribution extends StatelessWidget {
  final ContributionModel contribution;
  final ContributionPaginationStore contributionPaginationStore;

  const ViewContribution(
      {super.key,
      required this.contribution,
      required this.contributionPaginationStore});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);
    final store = Provider.of<AuthSessionStore>(context);
    final bankStore = Provider.of<BankStore>(context);
    bool mobile = isMobile(context);

    return Card(
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
              buildTitle('Contribuição #${contribution.contributionId}'),
              const Divider(),
              SizedBox(height: 16),
              buildDetailRow(mobile, 'Valor',
                  'R\$ ${contribution.amount.toStringAsFixed(2)}'),
              buildDetailRow(
                mobile,
                'Status',
                parseContributionStatus(contribution.status).friendlyName,
                statusColor: getStatusColor(
                    parseContributionStatus(contribution.status)),
              ),
              buildDetailRow(
                mobile,
                'Data',
                '${contribution.createdAt.day}/${contribution.createdAt.month}/${contribution.createdAt.year}',
              ),
              const SizedBox(height: 16),
              buildDetailRow(
                mobile,
                'Bano',
                '${bankStore.getBankName(contribution.bankId)}',
              ),
              const SizedBox(height: 16),
              buildSectionTitle('Membro'),
              Text(
                '${contribution.member.name} (ID: ${contribution.member.memberId})',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              buildSectionTitle('Conceito Financeiro'),
              Text(
                contribution.financeConcept.name,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 26),
              buildSectionTitle('Recibo de Transferência'),
              const SizedBox(height: 26),
              ContentViewer(url: contribution.bankTransferReceipt),
              const SizedBox(height: 46),
              if (_showButton(contribution, store))
                _buildButton(context, contribution.contributionId),
            ],
          ),
        ));
  }

  bool _showButton(ContributionModel contribution, AuthSessionStore store) {
    return parseContributionStatus(contribution.status) ==
                ContributionStatus.PENDING_VERIFICATION &&
            store.isAdmin() ||
        store.isTreasurer() ||
        store.isSuperUser();
  }

  Widget _buildButton(BuildContext context, String contributionId) {
    return Row(
      mainAxisAlignment:
          isMobile(context) ? MainAxisAlignment.center : MainAxisAlignment.end,
      children: [
        ButtonActionTable(
          color: AppColors.blue,
          text: 'Aprovar',
          onPressed: () async {
            await _updateContributionStatus(
                contributionId, ContributionStatus.PROCESSED);

            Navigator.of(context).pop();
          },
          icon: Icons.check,
        ),
        ButtonActionTable(
          color: Colors.red,
          text: "Rejeitar",
          onPressed: () async {
            await _updateContributionStatus(
                contributionId, ContributionStatus.REJECTED);

            Navigator.of(context).pop();
          },
          icon: Icons.cancel,
        )
      ],
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
            style: const TextStyle(
                fontSize: 16, fontFamily: AppFonts.fontSubTitle),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppFonts.fontText,
              color: statusColor, // Aplica el color aquí
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateContributionStatus(
      String contributionId, ContributionStatus status) async {
    contributionPaginationStore.updateStatusContribution(
        contributionId, status);
  }
}
