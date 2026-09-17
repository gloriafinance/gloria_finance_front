import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:gloria_finance/features/member_experience/commitments/store/member_commitment_pix_payment_store.dart';
import 'package:gloria_finance/features/member_experience/contributions/pages/contribute/widgets/pix_payment_code_panel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MemberCommitmentPixRouteArgs {
  final MemberCommitmentInstallment installment;
  final int installmentIndex;
  final int totalInstallments;

  const MemberCommitmentPixRouteArgs({
    required this.installment,
    required this.installmentIndex,
    required this.totalInstallments,
  });
}

class MemberCommitmentPixPaymentScreen extends StatefulWidget {
  final MemberCommitmentInstallment installment;
  final int installmentIndex;
  final int totalInstallments;

  const MemberCommitmentPixPaymentScreen({
    super.key,
    required this.installment,
    required this.installmentIndex,
    required this.totalInstallments,
  });

  @override
  State<MemberCommitmentPixPaymentScreen> createState() =>
      _MemberCommitmentPixPaymentScreenState();
}

class _MemberCommitmentPixPaymentScreenState
    extends State<MemberCommitmentPixPaymentScreen> {
  late final MemberCommitmentPixPaymentStore _store;
  bool _paymentHandled = false;

  @override
  void initState() {
    super.initState();
    _store = MemberCommitmentPixPaymentStore(widget.installment);
    _store.addListener(_handleStoreChanged);
    _store.createPayment();
  }

  @override
  void dispose() {
    _store
      ..removeListener(_handleStoreChanged)
      ..dispose();
    super.dispose();
  }

  void _handleStoreChanged() {
    if (_paymentHandled ||
        _store.status != MemberCommitmentPixPaymentUiStatus.paid) {
      return;
    }

    _paymentHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _store,
      child: Consumer<MemberCommitmentPixPaymentStore>(
        builder: (context, store, _) {
          final l10n = context.l10n;
          final currencySymbol =
              context.read<AuthSessionStore>().state.session.symbolFormatMoney;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                l10n.member_commitments_pix_title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.member_commitments_payment_installment_label} ${widget.installmentIndex} / ${widget.totalInstallments}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (store.isLoading) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
                Text(
                  l10n.member_commitments_pix_generating,
                  textAlign: TextAlign.center,
                ),
              ] else if (store.status ==
                  MemberCommitmentPixPaymentUiStatus.error) ...[
                Text(
                  l10n.member_commitments_pix_error,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: l10n.member_commitments_pix_retry,
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  icon: Icons.refresh,
                  onPressed: store.retry,
                ),
              ] else if (store.payment != null) ...[
                _PaymentContent(store: store, currencySymbol: currencySymbol),
                const SizedBox(height: 20),
                if (store.status == MemberCommitmentPixPaymentUiStatus.expired)
                  CustomButton(
                    text: l10n.member_commitments_pix_retry,
                    backgroundColor: AppColors.purple,
                    textColor: Colors.white,
                    icon: Icons.refresh,
                    onPressed: store.retry,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _PaymentContent extends StatelessWidget {
  final MemberCommitmentPixPaymentStore store;
  final String currencySymbol;

  const _PaymentContent({required this.store, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final payment = store.payment!;
    final copyPaste = payment.copyPaste;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AmountRow(
          l10n.member_commitments_pix_principal_amount,
          payment.principalAmount,
          currencySymbol: currencySymbol,
        ),
        _AmountRow(
          l10n.member_commitments_pix_transaction_fee,
          payment.transactionFee,
          currencySymbol: currencySymbol,
        ),
        const Divider(),
        _AmountRow(
          l10n.member_commitments_pix_total_amount,
          payment.chargeAmount,
          highlighted: true,
          currencySymbol: currencySymbol,
        ),
        if (payment.expirationDate != null) ...[
          const SizedBox(height: 8),
          Text(
            l10n.member_commitments_pix_expiration(
              DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(payment.expirationDate!.toLocal()),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (copyPaste != null && copyPaste.isNotEmpty) ...[
          const SizedBox(height: 20),
          PixPaymentCodePanel(
            copyPaste: copyPaste,
            codeLabel: l10n.member_commitments_pix_code_label,
            copyLabel: l10n.member_commitments_pix_copy,
            qrHint: l10n.member_contribution_pix_qr_hint,
            copiedMessage: l10n.member_commitments_pix_copy_success,
          ),
        ],
        const SizedBox(height: 16),
        if (store.status == MemberCommitmentPixPaymentUiStatus.waiting)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  l10n.member_commitments_pix_waiting,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        else
          Text(
            switch (store.status) {
              MemberCommitmentPixPaymentUiStatus.paid =>
                l10n.member_commitments_pix_paid,
              MemberCommitmentPixPaymentUiStatus.expired =>
                l10n.member_commitments_pix_expired,
              MemberCommitmentPixPaymentUiStatus.unknown => payment.status,
              _ => l10n.member_commitments_pix_waiting,
            },
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool highlighted;
  final String currencySymbol;

  const _AmountRow(
    this.label,
    this.amount, {
    this.highlighted = false,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            CurrencyFormatter.formatCurrency(amount, symbol: currencySymbol),
            style: TextStyle(
              fontWeight: highlighted ? FontWeight.bold : FontWeight.w500,
              fontSize: highlighted ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
