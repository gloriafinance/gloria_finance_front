import 'dart:convert';

import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/features/erp/accounts_receivable/models/accounts_receivable_model.dart';
import 'package:church_finance_bk/features/erp/widgets/content_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../payment_commitment_store.dart';
import 'buttons_accept_reject.dart';

class DetailsPaymentCommitment extends StatelessWidget {
  final String token;

  const DetailsPaymentCommitment({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PaymentCommitmentStore>(context);

    final decoded = utf8.decode(base64.decode(token));
    final data = jsonDecode(decoded);
    final accountReceivable = AccountsReceivableModel.fromJson(data);
    store.setToken(token);

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
            _buildInfoRow(
              'Valor Total:',
              formatCurrency(accountReceivable.amountTotal ?? 0),
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

            store.state.linkContract == ''
                ? _buildInstallmentsTable(accountReceivable)
                : ContentViewer(
                  url: store.state.linkContract,
                  title: 'Visualizar Contrato',
                ),

            store.state.makeRequest
                ? Loading()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Rejeitar',
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      onPressed: () => handleReject(context, store),
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
                      onPressed: () => handleAccept(context, store),
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

  Widget _buildInstallmentsTable(AccountsReceivableModel accountReceivable) {
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
