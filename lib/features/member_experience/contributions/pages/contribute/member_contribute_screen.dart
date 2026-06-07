import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/member_contribution_models.dart';
import '../../store/member_contribution_form_store.dart';
import 'widgets/member_contribution_wizard_steps.dart';

class MemberContributeScreen extends StatefulWidget {
  const MemberContributeScreen({super.key});

  @override
  State<MemberContributeScreen> createState() => _MemberContributeScreenState();
}

class _MemberContributeScreenState extends State<MemberContributeScreen> {
  static const int _totalSteps = 4;

  late MemberContributionFormStore _store;
  final ScrollController _scrollController = ScrollController();
  MultipartFile? _receiptFile;
  int _currentStep = 1;
  bool _hasSelectedType = false;
  bool _showCustomAmountInput = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final accountsStore = Provider.of<AvailabilityAccountsListStore>(
      context,
      listen: false,
    );
    final conceptStore = Provider.of<FinancialConceptStore>(
      context,
      listen: false,
    );
    _store = MemberContributionFormStore(accountsStore, conceptStore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _store.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _store,
      child: Consumer2<MemberContributionFormStore, FinancialConceptStore>(
        builder: (context, store, conceptStore, child) {
          final content = _buildStep(context, store, conceptStore);

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
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(10, 28, 10, 18),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: content,
                    ),
                  ),
                ),
              ),
              if (store.state.isSubmitting || store.state.isUploadingReceipt)
                const _SubmittingOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    MemberContributionFormStore store,
    FinancialConceptStore conceptStore,
  ) {
    final l10n = context.l10n;
    final offeringConcepts = _offeringConcepts(conceptStore);

    switch (_currentStep) {
      case 1:
        return _StepLayout(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          title: l10n.member_contribution_type_step_title,
          subtitle: l10n.member_contribution_type_step_subtitle,
          onBackPressed: _handleBack,
          body: ContributionTypeStep(
            selectedType: _hasSelectedType ? store.state.selectedType : null,
            onTypeSelected: (type) {
              setState(() {
                _hasSelectedType = true;
              });
              store.selectType(type);
              if (type == MemberContributionType.offering) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted || !_scrollController.hasClients) return;
                  final target = _scrollController.position.maxScrollExtent;
                  _scrollController.animateTo(
                    target,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                  );
                });
              }
            },
            offeringConcepts: offeringConcepts,
            selectedConceptId: store.state.financialConceptId,
            onConceptSelected: store.setFinancialConceptId,
          ),
          buttonText: l10n.member_contribution_continue_button,
          buttonIcon: Icons.arrow_forward,
          onPressed: _canContinueTypeStep(store) ? _nextStep : null,
        );
      case 2:
        return _StepLayout(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          title: l10n.member_contribution_amount_step_title,
          subtitle: l10n.member_contribution_amount_step_subtitle,
          onBackPressed: _previousStep,
          selectedAmount: store.state.amount,
          body: ContributionAmountStep(
            selectedAmount: store.state.amount,
            quickAmounts: store.state.quickAmounts,
            isCustomAmountSelected: _showCustomAmountInput,
            onQuickAmountSelected: (amount) {
              setState(() {
                _showCustomAmountInput = false;
              });
              store.selectAmount(amount);
            },
            onCustomAmountChanged: store.selectAmount,
            onCustomAmountSelected: () {
              setState(() {
                _showCustomAmountInput = true;
              });
            },
          ),
          buttonText: l10n.member_contribution_continue_button,
          buttonIcon: Icons.arrow_forward,
          onPressed: _hasValidAmount(store) ? _nextStep : null,
        );
      case 3:
        return _StepLayout(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          title: l10n.member_contribution_date_step_title,
          subtitle: l10n.member_contribution_date_step_subtitle,
          onBackPressed: _previousStep,
          selectedAmount: store.state.amount,
          body: ContributionDateStep(
            selectedDate: store.state.paidAt,
            onDateSelected: (date) {
              store.setPaidAt(date);
              _scrollToBottom();
            },
          ),
          buttonText: l10n.member_contribution_continue_button,
          buttonIcon: Icons.arrow_forward,
          onPressed: store.state.paidAt != null ? _nextStep : null,
        );
      default:
        return _StepLayout(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          title: l10n.member_contribution_receipt_step_title,
          subtitle: l10n.member_contribution_receipt_step_subtitle,
          onBackPressed: _previousStep,
          selectedAmount: store.state.amount,
          body: ContributionReceiptStep(
            fileName: store.state.receiptFileName,
            onFileSelected: (file) {
              setState(() {
                _receiptFile = file;
              });
              store.setReceiptFile(file, file.filename ?? 'receipt.jpg');
              _scrollToBottom();
            },
            onFileRemoved: () {
              setState(() {
                _receiptFile = null;
              });
              store.clearReceipt();
            },
          ),
          buttonText: l10n.member_contribution_send_button,
          buttonIcon: Icons.send,
          onPressed:
              store.state.isValid && !store.state.isSubmitting
                  ? () => _handleSubmit(store)
                  : null,
        );
    }
  }

  List<FinancialConceptModel> _offeringConcepts(
    FinancialConceptStore conceptStore,
  ) {
    return conceptStore.state.financialConcepts
        .where((concept) => concept.name.startsWith('Oferta'))
        .toList();
  }

  bool _canContinueTypeStep(MemberContributionFormStore store) {
    if (!_hasSelectedType) return false;
    if (store.state.selectedType == MemberContributionType.tithe) return true;
    return store.state.financialConceptId != null &&
        store.state.financialConceptId!.isNotEmpty;
  }

  bool _hasValidAmount(MemberContributionFormStore store) {
    return store.state.amount != null && store.state.amount! > 0;
  }

  void _nextStep() {
    if (_currentStep >= _totalSteps) return;
    setState(() {
      _currentStep += 1;
    });
  }

  void _previousStep() {
    if (_currentStep <= 1) return;
    setState(() {
      _currentStep -= 1;
    });
    _scrollToTop();
  }

  void _handleBack() {
    if (_currentStep == 1) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/dashboard');
      }
      return;
    }

    _previousStep();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _handleSubmit(MemberContributionFormStore store) async {
    final result = await store.submitContribution(context.l10n, _receiptFile);

    if (result == null || !mounted) return;

    switch (result.channel) {
      case MemberPaymentChannel.pix:
        context.push(
          '/member/contribute/pix/${result.contributionId}',
          extra: result.pixPayload,
        );
        break;

      case MemberPaymentChannel.boleto:
        context.push(
          '/member/contribute/boleto/${result.contributionId}',
          extra: result.boletoPayload,
        );
        break;

      case MemberPaymentChannel.externalWithReceipt:
        context.push(
          '/member/contribute/result',
          extra: {
            'success': true,
            'type': store.state.selectedType,
            'amount': store.state.amount,
            'paidAt': store.state.paidAt,
          },
        );
        break;
    }
  }
}

class _SubmittingOverlay extends StatelessWidget {
  const _SubmittingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withValues(alpha: 0.12),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8E5EF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.purple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepLayout extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;
  final String subtitle;
  final VoidCallback onBackPressed;
  final double? selectedAmount;
  final Widget body;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback? onPressed;

  const _StepLayout({
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.subtitle,
    required this.onBackPressed,
    this.selectedAmount,
    required this.body,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onBackPressed,
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: AppColors.purple,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Color(0xFFE8E5EF)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ContributionStepProgress(
                currentStep: currentStep,
                totalSteps: totalSteps,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        ContributionStepHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 28),
        if (selectedAmount != null) ...[
          SelectedAmountSummary(amount: selectedAmount),
          const SizedBox(height: 28),
        ],
        body,
        const SizedBox(height: 38),
        ContributionPrimaryButton(
          text: buttonText,
          icon: buttonIcon,
          onPressed: onPressed,
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
