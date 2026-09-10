import 'package:flutter/material.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/member_contribution_models.dart';
import '../../store/member_contribution_form_store.dart';
import 'member_contribute_pix_screen.dart';
import 'widgets/contribution_payment_method_cards.dart';
import 'widgets/member_contribution_wizard_steps.dart';

class MemberContributeScreen extends StatefulWidget {
  const MemberContributeScreen({super.key});

  @override
  State<MemberContributeScreen> createState() => _MemberContributeScreenState();
}

class _MemberContributeScreenState extends State<MemberContributeScreen> {
  MemberContributionFormStore? _store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_store != null) return;

    final accountsStore = Provider.of<AvailabilityAccountsListStore>(
      context,
      listen: false,
    );
    final conceptStore = Provider.of<FinancialConceptStore>(
      context,
      listen: false,
    );

    _store = MemberContributionFormStore(accountsStore, conceptStore);
    _store!.addListener(_handleStoreChanged);
    _store!.initialize();
  }

  @override
  void dispose() {
    _store?.removeListener(_handleStoreChanged);
    _store?.dispose();
    super.dispose();
  }

  void _handleStoreChanged() {
    final store = _store;
    if (store == null || !mounted || !store.state.pixPaymentFinished) {
      return;
    }

    final type = store.state.selectedType;
    final amount = store.state.amount;
    store.consumePixPaymentFinished();

    context.go(
      '/member/contribute/result',
      extra: {
        'success': true,
        'type': type,
        'amount': amount,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = _store;
    if (store == null) {
      return const Loading();
    }

    return ChangeNotifierProvider.value(
      value: store,
      child: Consumer<MemberContributionFormStore>(
        builder: (context, contributionStore, child) {
          final content = _buildStep(context, contributionStore);

          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE8E5EF)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(10, 28, 10, 18),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: content,
                    ),
                  ),
                ),
              ),
              if (contributionStore.state.isSubmitting ||
                  contributionStore.state.isUploadingReceipt)
                const Loading(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    MemberContributionFormStore store,
  ) {
    final l10n = context.l10n;
    final state = store.state;

    switch (state.currentStep) {
      case 1:
        return _StepLayout(
          currentStep: state.currentStep,
          totalSteps: state.totalSteps,
          title: l10n.member_contribution_type_step_title,
          subtitle: l10n.member_contribution_type_step_subtitle,
          body: ContributionTypeStep(
            selectedType: state.hasSelectedType ? state.selectedType : null,
            onTypeSelected: store.selectType,
            offeringConcepts: store.offeringConcepts,
            selectedConceptId: state.financialConceptId,
            onConceptSelected: store.setFinancialConceptId,
          ),
          buttonText: l10n.member_contribution_continue_button,
          buttonIcon: Icons.arrow_forward,
          onPressed: state.canContinueTypeStep ? store.nextStep : null,
        );

      case 2:
        return _StepLayout(
          currentStep: state.currentStep,
          totalSteps: state.totalSteps,
          title: l10n.member_contribution_amount_step_title,
          subtitle: l10n.member_contribution_amount_step_subtitle,
          selectedAmount: state.amount,
          body: ContributionAmountStep(
            selectedAmount: state.amount,
            quickAmounts: state.quickAmounts,
            isCustomAmountSelected: state.showCustomAmountInput,
            onQuickAmountSelected: (amount) {
              store.setCustomAmountInput(false);
              store.selectAmount(amount);
            },
            onCustomAmountChanged: store.selectAmount,
            onCustomAmountSelected: () => store.setCustomAmountInput(true),
          ),
          buttonText: l10n.member_contribution_continue_button,
          buttonIcon: Icons.arrow_forward,
          onPressed: state.hasValidAmount ? store.nextStep : null,
        );

      case 3:
        return _StepLayout(
          currentStep: state.currentStep,
          totalSteps: state.totalSteps,
          title: l10n.member_contribution_payment_method_question,
          subtitle:
              store.canPayWithPix
                  ? l10n.member_contribution_payment_method_pix_description
                  : l10n.member_contribution_payment_method_manual_description,
          selectedAmount: state.amount,
          body: ContributionPaymentMethodCards(
            selectedChannel: state.selectedChannel,
            onChannelSelected: store.selectPaymentChannel,
            enabledChannels: [
              MemberPaymentChannel.externalWithReceipt,
              if (store.canPayWithPix) MemberPaymentChannel.pix,
            ],
          ),
          buttonText: l10n.member_contribution_continue_button,
          buttonIcon: Icons.arrow_forward,
          onPressed: state.selectedChannel != null ? store.nextStep : null,
        );

      case 4:
        if (state.selectedChannel == MemberPaymentChannel.pix) {
          final pix = store.selectedPix;
          final concept = store.selectedFinancialConcept;

          if (pix == null) {
            return _StepLayout(
              currentStep: state.currentStep,
              totalSteps: state.totalSteps,
              title: l10n.member_contribution_pix_title,
              subtitle: l10n.member_contribution_payment_method_manual_description,
              body: ContributionPaymentMethodCards(
                selectedChannel: null,
                onChannelSelected: store.selectPaymentChannel,
                enabledChannels: const [
                  MemberPaymentChannel.externalWithReceipt,
                ],
              ),
              buttonText: l10n.member_contribution_continue_button,
              buttonIcon: Icons.arrow_forward,
              onPressed: null,
            );
          }

          return _StepLayout(
            currentStep: state.currentStep,
            totalSteps: state.totalSteps,
            title: l10n.member_contribution_pix_title,
            subtitle: l10n.member_contribution_payment_method_pix_description,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MemberContributePixScreen(
                  pix: pix,
                  amount: state.amount!,
                  description: concept?.name ?? '',
                ),
                if (store.canConfirmPixPaymentManually) ...[
                  const SizedBox(height: 24),
                  ContributionPrimaryButton(
                    text: _pixAlreadyPaidButtonLabel(context),
                    icon: Icons.check_circle_outline,
                    onPressed: store.confirmPixPaymentManually,
                  ),
                ],
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: store.backToPaymentMethod,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(
                    MaterialLocalizations.of(context).backButtonTooltip,
                  ),
                ),
              ],
            ),
            buttonText: '',
            buttonIcon: Icons.check,
            onPressed: null,
            showAction: false,
          );
        }

        return _StepLayout(
          currentStep: state.currentStep,
          totalSteps: state.totalSteps,
          title: l10n.member_contribution_date_step_title,
          subtitle: l10n.member_contribution_date_step_subtitle,
          selectedAmount: state.amount,
          body: ContributionDateStep(
            selectedDate: state.paidAt,
            onDateSelected: store.setPaidAt,
          ),
          buttonText: l10n.member_contribution_continue_button,
          buttonIcon: Icons.arrow_forward,
          onPressed: state.paidAt != null ? store.nextStep : null,
        );

      default:
        return _StepLayout(
          currentStep: state.currentStep,
          totalSteps: state.totalSteps,
          title: l10n.member_contribution_receipt_step_title,
          subtitle: l10n.member_contribution_receipt_step_subtitle,
          selectedAmount: state.amount,
          body: ContributionReceiptStep(
            fileName: state.receiptFileName,
            onFileSelected: (file) {
              store.setReceiptFile(file, file.filename ?? 'receipt.jpg');
            },
            onFileRemoved: store.clearReceipt,
          ),
          buttonText: l10n.member_contribution_send_button,
          buttonIcon: Icons.send,
          onPressed:
              state.isValid && !state.isSubmitting
                  ? () => _handleSubmit(store)
                  : null,
        );
    }
  }

  String _pixAlreadyPaidButtonLabel(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'es':
        return '¿Ya realizaste el pago?';
      case 'en':
        return 'Have you already made the payment?';
      default:
        return 'Já realizou o pagamento?';
    }
  }

  Future<void> _handleSubmit(MemberContributionFormStore store) async {
    final success = await store.submitContribution(context.l10n);

    if (!success || !mounted) return;

    context.push(
      '/member/contribute/result',
      extra: {
        'success': true,
        'type': store.state.selectedType,
        'amount': store.state.amount,
        'paidAt': store.state.paidAt,
      },
    );
  }
}

class _StepLayout extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;
  final String subtitle;
  final double? selectedAmount;
  final Widget body;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback? onPressed;
  final bool showAction;

  const _StepLayout({
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.subtitle,
    this.selectedAmount,
    required this.body,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ContributionStepProgress(
          currentStep: currentStep,
          totalSteps: totalSteps,
        ),
        const SizedBox(height: 30),
        ContributionStepHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 28),
        if (selectedAmount != null) ...[
          SelectedAmountSummary(amount: selectedAmount),
          const SizedBox(height: 28),
        ],
        body,
        if (showAction) ...[
          const SizedBox(height: 38),
          ContributionPrimaryButton(
            text: buttonText,
            icon: buttonIcon,
            onPressed: onPressed,
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}
