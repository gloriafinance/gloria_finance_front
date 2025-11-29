import 'package:church_finance_bk/core/layout/view_detail_widgets.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/erp/settings/banks/models/bank_model.dart';
import 'package:flutter/material.dart';

class ViewAvailabilityAccount extends StatelessWidget {
  final AvailabilityAccountModel account;

  const ViewAvailabilityAccount({super.key, required this.account});

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
            buildTitle('Conta #${account.availabilityAccountId}'),
            const Divider(),
            SizedBox(height: 16),
            buildDetailRow(mobile, 'Nome', account.accountName),
            buildDetailRow(
              mobile,
              'Saldo',
              'R\$ ${account.balance.toStringAsFixed(2)}',
            ),
            buildDetailRow(mobile, 'Tipo', account.accountType),
            buildDetailRow(mobile, 'Ativa', account.active ? 'Sim' : 'Não'),
            const Divider(),
            if (account.source != null &&
                account.accountType == AccountType.BANK.apiValue)
              _sourceBank(account.getSource()),
          ],
        ),
      ),
    );
  }

  Widget _sourceBank(BankModel bank) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('Dados do Banco'),
        const Divider(),
        SizedBox(height: 16),
        buildDetailRow(false, 'Nome', bank.name),
        buildDetailRow(false, 'Codigo de banco', bank.bankInstruction.codeBank),
        buildDetailRow(false, 'Agência', bank.bankInstruction.agency),
        buildDetailRow(false, 'Conta', bank.bankInstruction.account),
      ],
    );
  }
}
