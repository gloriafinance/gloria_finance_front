import 'dart:convert';

import 'package:church_finance_bk/auth/widgets/layout_auth.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/app_logo.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/accounts_receivable/models/accounts_receivable_model.dart';
import 'package:church_finance_bk/helpers/formatter.dart';
import 'package:church_finance_bk/helpers/general.dart';
import 'package:flutter/material.dart';

import 'widgets/details_payment_commitment.dart';

class PaymentCommitment extends StatelessWidget {
  final String? token;

  const PaymentCommitment({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    if (token == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(
          child: Text(
            'Nenhum token válido recebido',
            style: TextStyle(fontFamily: AppFonts.fontText),
          ),
        ),
      );
    }

    try {
      final decoded = utf8.decode(base64.decode(token!));
      final data = jsonDecode(decoded); // Convierte el string JSON a Map
      final model = AccountsReceivableModel.fromJson(data);

      return LayoutAuth(
        height: 750,
        width: isMobile(context) ? null : 820,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: const ApplicationLogo(height: 100),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Detalhes do Compromisso',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                      fontFamily: AppFonts.fontTitle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: DetailsPaymentCommitment(
                  accountReceivable: model,
                  onAccept: () => _handleAccept(context, model),
                  onReject: () => _handleReject(context, model),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Erro',
            style: TextStyle(fontFamily: AppFonts.fontTitle),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Erro ao processar o token',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontTitle,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Detalhe: $e',
                  style: const TextStyle(fontFamily: AppFonts.fontText),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontFamily: AppFonts.fontText),
                  ),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _handleAccept(BuildContext context, AccountsReceivableModel model) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Compromisso Aceito',
              style: TextStyle(fontFamily: AppFonts.fontTitle),
            ),
            content: Text(
              'Você irá aceitar o compromisso de pagamento no valor total de ${formatCurrency(model.amountTotal!)} ',
              style: const TextStyle(fontFamily: AppFonts.fontText),
            ),
            actions: [
              ButtonActionTable(
                color: AppColors.mustard,
                text: "Cancelar",
                onPressed: () {
                  Navigator.of(context).pop();
                  // Aquí podrías navegar a otra pantalla o atualizar el estado
                },
                icon: Icons.cancel_outlined,
              ),
              ButtonActionTable(
                color: AppColors.purple,
                text: "OK",
                onPressed: () {
                  Navigator.of(context).pop();
                  // Aquí podrías navegar a otra pantalla o atualizar el estado
                },
                icon: Icons.check_circle_outline,
              ),
            ],
          ),
    );
  }

  void _handleReject(BuildContext context, AccountsReceivableModel model) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Confirmar Rejeição',
              style: TextStyle(fontFamily: AppFonts.fontTitle),
            ),
            content: const Text(
              'Tem certeza de que deseja rejeitar este compromisso de pagamento?',
              style: TextStyle(fontFamily: AppFonts.fontText),
            ),
            actions: [
              // TextButton(
              //   onPressed: () => Navigator.of(context).pop(),
              //   child: const Text(
              //     'Cancelar',
              //     style: TextStyle(fontFamily: AppFonts.fontText),
              //   ),
              // ),
              ButtonActionTable(
                color: AppColors.mustard,
                text: "Cancelar",
                onPressed: () {
                  Navigator.of(context).pop();
                  // Aquí podrías navegar a otra pantalla o atualizar el estado
                },
                icon: Icons.cancel_outlined,
              ),
              ButtonActionTable(
                color: Colors.red,
                text: "Rejeitar",
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text(
                            'Compromisso Rejeitado',
                            style: TextStyle(fontFamily: AppFonts.fontTitle),
                          ),
                          content: const Text(
                            'Você rejeitou o compromisso de pagamento.',
                            style: TextStyle(fontFamily: AppFonts.fontText),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Aquí podrías navegar a otra pantalla o atualizar el estado
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(fontFamily: AppFonts.fontText),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                icon: Icons.cancel_outlined,
              ),
            ],
          ),
    );
  }
}
