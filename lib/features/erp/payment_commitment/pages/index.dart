import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/app_logo.dart';
import 'package:church_finance_bk/features/auth/widgets/layout_auth.dart';
import 'package:church_finance_bk/features/erp/payment_commitment/payment_commitment_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/details_payment_commitment.dart';

class PaymentCommitment extends StatefulWidget {
  final String? token;

  const PaymentCommitment({super.key, this.token});

  @override
  State<PaymentCommitment> createState() => _PaymentCommitmentState();
}

class _PaymentCommitmentState extends State<PaymentCommitment> {
  bool makeRequest = false;

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    if (widget.token == null) {
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
      return ChangeNotifierProvider(
        create: (_) => PaymentCommitmentStore(),
        child: LayoutAuth(
          height: isMobile(context) ? 750 : 920,
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
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
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
                  child: DetailsPaymentCommitment(token: widget.token!),
                ),
              ),
            ],
          ),
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
}
