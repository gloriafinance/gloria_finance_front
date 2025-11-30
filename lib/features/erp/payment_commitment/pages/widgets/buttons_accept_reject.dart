import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/core/utils/formatter.dart';
import 'package:flutter/material.dart';

//import 'package:go_router/go_router.dart';

import '../../payment_commitment_store.dart';

void handleAccept(BuildContext context, PaymentCommitmentStore store) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text(
            'Compromisso Aceito',
            style: TextStyle(fontFamily: AppFonts.fontTitle),
          ),
          content: Text(
            'Você irá aceitar o compromisso de pagamento no valor total de ${formatCurrency(store.state.amount)} ',
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
              text: "ACEITAR",
              onPressed: () {
                store.setAction('ACCEPTED');
                store.send().then((value) {
                  Navigator.of(context).pop();
                });
              },
              icon: Icons.check_circle_outline,
            ),
          ],
        ),
  );
}

void handleReject(BuildContext context, PaymentCommitmentStore store) {
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
                store.setAction('DENIED');
                store.send().then((value) {
                  Toast.showMessage(
                    "Você rejeitou o compromisso de apgo",
                    ToastType.warning,
                  );
                  Navigator.of(context).pop();
                  //context.go('/');
                });
              },
              icon: Icons.cancel_outlined,
            ),
          ],
        ),
  );
}
