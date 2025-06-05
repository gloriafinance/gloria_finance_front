import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/finance/accounts_receivable/models/accounts_receivable_model.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

class DetailsPaymentCommitment extends StatelessWidget {
  final AccountsReceivableModel accountReceivable;
  final Function() onAccept;
  final Function() onReject;

  const DetailsPaymentCommitment({
    super.key,
    required this.accountReceivable,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Cambia el color de fondo aquí
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            _buildInfoRow('Descrição:', accountReceivable.description),
            _buildInfoRow('Devedor:', accountReceivable.debtor.name),
            _buildInfoRow('Estado:', _getStatusText(accountReceivable.status)),
            _buildInfoRow(
              'Valor Total:',
              formatCurrency(accountReceivable.amountTotal ?? 0),
            ),
            _buildInfoRow(
              'Valor Pago:',
              formatCurrency(accountReceivable.amountPaid ?? 0),
            ),
            _buildInfoRow(
              'Valor Pendente:',
              formatCurrency(accountReceivable.amountPending ?? 0),
            ),
            _buildInfoRow('Criado em:', accountReceivable.createdAtFormatted),
            _buildInfoRow(
              'Atualizado em:',
              accountReceivable.updatedAtFormatted,
            ),

            const SizedBox(height: 30),
            Text(
              'Parcelas:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),

            _buildInstallmentsTable(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Rejeitar',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  onPressed: onReject,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                const SizedBox(width: 16),
                CustomButton(
                  text: 'Aceitar',
                  backgroundColor: AppColors.green,
                  textColor: Colors.white,
                  onPressed: onAccept,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontFamily: AppFonts.fontText)),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentsTable() {
    return CustomTable(
      headers: const ['N°', 'Vencimento', 'Valor'],
      data: FactoryDataTable(
        data: accountReceivable.installments,
        dataBuilder: (installment) {
          final index = accountReceivable.installments.indexOf(installment) + 1;
          return [
            index.toString(),
            convertDateFormatToDDMMYYYY(installment.dueDate.toString()),
            formatCurrency(installment.amount),
          ];
        },
      ),
    );
  }

  String _getStatusText(String? status) {
    if (status == null) return 'Desconhecido';

    try {
      AccountsReceivableStatus statusEnum = AccountsReceivableStatus.values
          .firstWhere(
            (e) => e.apiValue == status,
            orElse: () => throw Exception('Estado desconhecido'),
          );
      return statusEnum.friendlyName;
    } catch (e) {
      return status;
    }
  }
}

class DetailsPaymentCommitmentView extends StatelessWidget {
  final AccountsReceivableModel accountReceivable;
  final Function(AccountsReceivableModel) onAccept;
  final Function(AccountsReceivableModel) onReject;
  final bool isLoading;

  const DetailsPaymentCommitmentView({
    super.key,
    required this.accountReceivable,
    required this.onAccept,
    required this.onReject,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : DetailsPaymentCommitment(
          accountReceivable: accountReceivable,
          onAccept: () => onAccept(accountReceivable),
          onReject: () => onReject(accountReceivable),
        );
  }
}
