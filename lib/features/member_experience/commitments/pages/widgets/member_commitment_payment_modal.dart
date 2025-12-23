import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/currency_formatter.dart';
import 'package:church_finance_bk/core/utils/date_formatter.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/member_experience/commitments/store/member_commitment_payment_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberCommitmentPaymentModal extends StatelessWidget {
  final BuildContext parentContext;
  final List<AvailabilityAccountModel> accounts;

  const MemberCommitmentPaymentModal({
    super.key,
    required this.parentContext,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final store = context.watch<MemberCommitmentPaymentStore>();

    if (accounts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          l10n.member_commitments_payment_missing_account,
          style: const TextStyle(
            fontFamily: AppFonts.fontText,
            color: Colors.redAccent,
          ),
        ),
      );
    }

    final selectedAccountId =
        store.selectedAvailabilityAccountId ??
        accounts.first.availabilityAccountId;
    if (store.selectedAvailabilityAccountId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        store.setAvailabilityAccount(selectedAccountId);
      });
    }

    final selectedAccount = accounts.firstWhere(
      (acc) => acc.availabilityAccountId == selectedAccountId,
      orElse: () => accounts.first,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.member_commitments_payment_account_label,
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
            value: selectedAccount.accountName,
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
            onChanged: (value) {
              if (value != null) {
                final account = accounts.firstWhere(
                  (acc) => acc.accountName == value,
                  orElse: () => selectedAccount,
                );
                store.setAvailabilityAccount(account.availabilityAccountId);
              }
            },
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.purple),
            dropdownColor: Colors.white,
          ),
          const SizedBox(height: 16),
          _ChannelGrid(account: selectedAccount),
          const SizedBox(height: 16),
          Input(
            label: l10n.member_commitments_payment_amount_label,
            initialValue:
                store.amount != null
                    ? CurrencyFormatter.formatCurrency(store.amount!)
                    : '',
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
            onChanged: (value) {
              if (value.isNotEmpty) {
                final amount = CurrencyFormatter.cleanCurrency(value);
                store.setAmount(amount);
              }
            },
          ),
          Input(
            label: l10n.member_commitments_payment_paid_at_label,
            initialValue:
                store.paidAt != null ? formatDateToDDMMYYYY(store.paidAt!) : '',
            readOnly: true,
            onChanged: (_) {},
            onTap: () async {
              final date = await selectDate(
                context,
                initialDate: store.paidAt ?? DateTime.now(),
              );
              if (date != null) store.setPaidAt(date);
            },
            iconRight: const Icon(
              Icons.calendar_today,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 8),
          UploadFile(
            label: l10n.member_commitments_payment_voucher_label,
            multipartFile: (MultipartFile file) {
              store.setVoucher(file);
            },
          ),
          Input(
            label: l10n.member_commitments_payment_observation_label,
            maxLines: 3,
            initialValue: store.observation,
            onChanged: store.setObservation,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: l10n.member_commitments_payment_submit,
            backgroundColor: AppColors.purple,
            textColor: Colors.white,
            onPressed:
                store.isSubmitting
                    ? null
                    : () async {
                      if (!store.isValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.member_commitments_payment_required_fields_error,
                            ),
                          ),
                        );
                        return;
                      }
                      final success = await store.submit();
                      if (success && context.mounted) {
                        Navigator.of(context).pop(true);
                        if (parentContext.mounted) {
                          ScaffoldMessenger.of(parentContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.member_commitments_payment_success,
                              ),
                            ),
                          );
                          Navigator.of(parentContext).pop(true);
                        }
                      }
                    },
          ),
        ],
      ),
    );
  }
}

class _ChannelGrid extends StatelessWidget {
  final AvailabilityAccountModel account;

  const _ChannelGrid({required this.account});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final channels = <Widget>[];

    if (account.configurations?.enablePix ?? false) {
      channels.add(
        _ChannelCard(
          icon: Icons.qr_code_2,
          title: 'PIX',
          description: l10n.member_contribution_payment_method_pix_description,
        ),
      );
    }
    if (account.configurations?.enableBankSlip ?? false) {
      channels.add(
        _ChannelCard(
          icon: Icons.receipt_long,
          title: l10n.member_contribution_payment_method_boleto_title,
          description:
              l10n.member_contribution_payment_method_boleto_description,
        ),
      );
    }
    // channels.add(
    //   _ChannelCard(
    //     icon: Icons.file_upload,
    //     title: l10n.member_commitments_payment_methods_manual,
    //     description: l10n.member_commitments_payment_methods_manual_hint,
    //   ),
    // );

    return Wrap(spacing: 12, runSpacing: 12, children: channels);
  }
}

class _ChannelCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ChannelCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.purple),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
