import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/currency_formatter.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../widgets/member_header.dart';
import '../../models/member_contribution_models.dart';
import '../../store/member_contribution_form_store.dart';
import 'widgets/contribution_payment_method_cards.dart';
import 'widgets/contribution_receipt_uploader.dart';
import 'widgets/contribution_type_selector.dart';

class MemberContributeScreen extends StatefulWidget {
  const MemberContributeScreen({super.key});

  @override
  State<MemberContributeScreen> createState() => _MemberContributeScreenState();
}

class _MemberContributeScreenState extends State<MemberContributeScreen> {
  late MemberContributionFormStore _store;
  MultipartFile? _receiptFile;
  bool _showCustomAmountInput = false;

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
      child: Consumer<MemberContributionFormStore>(
        builder: (context, store, child) {
          return Column(
            children: [
              MemberHeaderWidget(
                title: context.l10n.member_contribution_new_button,
                onBack: () => context.pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // _buildHeader(),
                        // Header moved up
                        _buildTypeSelector(store),
                        _buildDestinationDropdown(store),
                        if (store.state.selectedType ==
                            MemberContributionType.offering)
                          _buildFinancialConceptDropdown(store),
                        _buildAmountSelector(store),
                        const SizedBox(height: 24),
                        _buildPaymentMethodCards(store),
                        const SizedBox(height: 24),
                        if (store.state.selectedChannel ==
                            MemberPaymentChannel.externalWithReceipt) ...[
                          _buildReceiptUploader(store),
                          const SizedBox(height: 24),
                        ],
                        _buildMessageField(store),
                        const SizedBox(height: 32),
                        _buildContinueButton(store),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              if (store.state.isSubmitting || store.state.isUploadingReceipt)
                const Loading(),
            ],
          );
        },
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     margin: const EdgeInsets.only(bottom: 24),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.shade200,
  //           offset: const Offset(0, 2),
  //           blurRadius: 8,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Obrigado pela sua generosidade',
  //           style: TextStyle(
  //             fontFamily: AppFonts.fontTitle,
  //             fontSize: 20,
  //             color: AppColors.black,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           'Contribuir é um ato de adoração. Use esta tela para dízimos e ofertas.',
  //           style: TextStyle(
  //             fontFamily: AppFonts.fontText,
  //             fontSize: 14,
  //             color: Colors.grey.shade600,
  //             height: 1.5,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTypeSelector(MemberContributionFormStore store) {
    return ContributionTypeSelector(
      selectedType: store.state.selectedType,
      onTypeSelected: store.selectType,
    );
  }

  Widget _buildDestinationDropdown(MemberContributionFormStore store) {
    final l10n = context.l10n;
    final accounts = store.availabilityAccounts;
    if (accounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: l10n.member_contribution_destination_label,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: AppFonts.fontText,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.purple, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
        value:
            store.state.selectedDestinationId != null
                ? accounts
                    .firstWhere(
                      (a) =>
                          a.availabilityAccountId ==
                          store.state.selectedDestinationId,
                      orElse: () => accounts.first,
                    )
                    .accountName
                : null,
        items:
            accounts.map((account) {
              return DropdownMenuItem<String>(
                value: account.accountName,
                child: Text(
                  account.accountName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                    fontFamily: AppFonts.fontText,
                  ),
                ),
              );
            }).toList(),
        onChanged: (accountName) {
          if (accountName != null) {
            final account = accounts.firstWhere(
              (a) => a.accountName == accountName,
            );
            store.selectDestination(account.availabilityAccountId);
          }
        },
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.purple),
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildFinancialConceptDropdown(MemberContributionFormStore store) {
    final l10n = context.l10n;
    final conceptStore = Provider.of<FinancialConceptStore>(context);
    final concepts =
        conceptStore.state.financialConcepts
            .where((e) => e.name.startsWith("Oferta"))
            .toList();

    if (concepts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: l10n.member_contribution_offering_concept_label,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: AppFonts.fontText,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.purple, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
        value: store.state.financialConceptId,
        items:
            concepts.map((concept) {
              return DropdownMenuItem<String>(
                value: concept.financialConceptId,
                child: Text(
                  concept.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                    fontFamily: AppFonts.fontText,
                  ),
                ),
              );
            }).toList(),
        onChanged: (value) {
          if (value != null) {
            store.setFinancialConceptId(value);
          }
        },
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.purple),
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildAmountSelector(MemberContributionFormStore store) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              l10n.member_contribution_value_label,
              style: const TextStyle(
                color: AppColors.purple,
                fontFamily: AppFonts.fontTitle,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...store.state.quickAmounts.map((amount) {
              final isSelected =
                  store.state.amount == amount && !_showCustomAmountInput;
              return ChoiceChip(
                label: Text(
                  'R\$ ${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                    color: isSelected ? Colors.white : AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _showCustomAmountInput = false;
                    });
                    store.selectAmount(amount);
                  }
                },
                selectedColor: AppColors.purple,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.purple : Colors.grey.shade300,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              );
            }),
            ChoiceChip(
              label: Text(
                l10n.member_contribution_amount_other,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: _showCustomAmountInput,
              onSelected: (selected) {
                setState(() {
                  _showCustomAmountInput = selected;
                  if (!selected) {
                    store.selectAmount(store.state.quickAmounts.first);
                  }
                });
              },
              selectedColor: AppColors.purple,
              labelStyle: TextStyle(
                color: _showCustomAmountInput ? Colors.white : AppColors.black,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(
                color:
                    _showCustomAmountInput
                        ? AppColors.purple
                        : Colors.grey.shade300,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ],
        ),
        if (_showCustomAmountInput) ...[
          Input(
            label: l10n.member_contribution_value_label,
            initialValue:
                store.state.amount != null
                    ? CurrencyFormatter.formatCurrency(store.state.amount!)
                    : '',
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
            onChanged: (value) {
              if (value.isNotEmpty) {
                try {
                  final amount = CurrencyFormatter.cleanCurrency(value);
                  if (amount > 0) {
                    store.selectAmount(amount);
                  }
                } catch (e) {
                  // Invalid input, ignore
                }
              }
            },
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentMethodCards(MemberContributionFormStore store) {
    // Get enabled channels based on selected account configurations
    final enabledChannels = _getEnabledChannels(store);

    return ContributionPaymentMethodCards(
      selectedChannel: store.state.selectedChannel,
      onChannelSelected: store.selectPaymentChannel,
      enabledChannels: enabledChannels,
    );
  }

  List<MemberPaymentChannel> _getEnabledChannels(
    MemberContributionFormStore store,
  ) {
    final selectedAccountId = store.state.selectedDestinationId;
    if (selectedAccountId == null) {
      return [MemberPaymentChannel.externalWithReceipt];
    }

    final account = store.availabilityAccounts.firstWhere(
      (a) => a.availabilityAccountId == selectedAccountId,
      orElse: () => store.availabilityAccounts.first,
    );

    final config = account.configurations;
    final channels = <MemberPaymentChannel>[];

    // If configurations is null or empty, only show manual receipt upload
    if (config == null) {
      return [MemberPaymentChannel.externalWithReceipt];
    }

    if (config.enablePix) {
      channels.add(MemberPaymentChannel.pix);
    }
    if (config.enableBankSlip) {
      channels.add(MemberPaymentChannel.boleto);
    }
    // Always show manual receipt upload
    channels.add(MemberPaymentChannel.externalWithReceipt);

    return channels;
  }

  Widget _buildReceiptUploader(MemberContributionFormStore store) {
    return ContributionReceiptUploader(
      paidAt: store.state.paidAt,
      onDateSelected: store.setPaidAt,
      onFileSelected: (file) {
        setState(() {
          _receiptFile = file;
        });
        store.setReceiptFile(file, file.filename ?? 'receipt.pdf');
      },
      fileName: store.state.receiptFileName,
    );
  }

  Widget _buildMessageField(MemberContributionFormStore store) {
    return Input(
      label: context.l10n.member_contribution_message_label,
      maxLines: 3,
      initialValue: store.state.message,
      onChanged: store.setMessage,
    );
  }

  Widget _buildContinueButton(MemberContributionFormStore store) {
    return CustomButton(
      text: context.l10n.member_contribution_continue_button,
      backgroundColor: AppColors.purple,
      textColor: Colors.white,
      onPressed:
          store.state.isValid && !store.state.isSubmitting
              ? () => _handleSubmit(store)
              : null,
    );
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
