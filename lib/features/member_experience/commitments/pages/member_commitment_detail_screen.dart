import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:gloria_finance/features/member_experience/commitments/store/member_commitment_payment_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/member_commitment_installments_timeline.dart';
import 'widgets/member_commitment_payment_modal.dart';
import 'widgets/member_commitment_summary_card.dart';

class MemberCommitmentDetailScreen extends StatefulWidget {
  final MemberCommitmentModel commitment;

  const MemberCommitmentDetailScreen({super.key, required this.commitment});

  @override
  State<MemberCommitmentDetailScreen> createState() =>
      _MemberCommitmentDetailScreenState();
}

class _MemberCommitmentDetailScreenState
    extends State<MemberCommitmentDetailScreen> {
  late final AvailabilityAccountsListStore _accountsStore;

  @override
  void initState() {
    super.initState();
    _accountsStore =
        AvailabilityAccountsListStore()..addListener(_handleAccountsChanged);
    _accountsStore.searchAvailabilityAccounts();
  }

  @override
  void dispose() {
    _accountsStore.removeListener(_handleAccountsChanged);
    _accountsStore.dispose();
    super.dispose();
  }

  void _handleAccountsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openPaymentModal(
    MemberCommitmentInstallment installment,
  ) async {
    final accounts = _accountsStore.state.availabilityAccounts;
    final paymentStore = MemberCommitmentPaymentStore(widget.commitment)
      ..setInstallment(installment);

    await ModalPage(
      title: context.l10n.member_commitments_payment_modal_title,
      body: ChangeNotifierProvider<MemberCommitmentPaymentStore>.value(
        value: paymentStore,
        child: MemberCommitmentPaymentModal(
          parentContext: context,
          accounts: accounts,
        ),
      ),
      width: 520,
    ).show<bool>(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final commitment = widget.commitment;

    return ListView(
      children: [
        _DetailHeader(
          title: l10n.member_commitments_detail_title,
          subtitle: l10n.member_commitments_detail_subtitle,
          onBack: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 16),
        MemberCommitmentSummaryCard(commitment: commitment),
        const SizedBox(height: 16),
        MemberCommitmentNextInstallmentCard(
          commitment: commitment,
          onPayInstallment: _openPaymentModal,
        ),
        const SizedBox(height: 16),
        MemberCommitmentInstallmentsTimeline(
          commitment: commitment,
          onPayInstallment: _openPaymentModal,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const _DetailHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.fontText,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
