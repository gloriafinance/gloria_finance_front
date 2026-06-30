import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/view_detail_widgets.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/contributions/models/contribution_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/content_viewer.dart';
import '../../../helpers/contribution.helper.dart';
import '../../../store/contribution_pagination_store.dart';

class ViewContribution extends StatefulWidget {
  final ContributionModel contribution;
  final ContributionPaginationStore contributionPaginationStore;

  const ViewContribution({
    super.key,
    required this.contribution,
    required this.contributionPaginationStore,
  });

  @override
  State<ViewContribution> createState() => _ViewContributionState();
}

class _ViewContributionState extends State<ViewContribution> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedAvailabilityAccountId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedAvailabilityAccountId = null;
  }

  @override
  Widget build(BuildContext context) {
    Toast.init(context);
    final store = Provider.of<AuthSessionStore>(context);
    final availabilityStore = Provider.of<AvailabilityAccountsListStore>(
      context,
    );
    final accounts = _availableAccounts(
      availabilityStore.state.availabilityAccounts,
    );
    final mobile = isMobile(context);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(
                context.l10n.contributions_table_modal_title(
                  widget.contribution.contributionId,
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),
              buildDetailRow(
                mobile,
                context.l10n.contributions_view_field_amount,
                CurrencyFormatter.formatCurrency(
                  widget.contribution.amount,
                  symbol: widget.contribution.account?.symbol,
                ),
              ),
              buildDetailRow(
                mobile,
                context.l10n.contributions_view_field_status,
                getContributionStatusLabel(
                  context,
                  parseContributionStatus(widget.contribution.status),
                ),
                statusColor: getContributionStatusColor(
                  parseContributionStatus(widget.contribution.status),
                ),
              ),
              buildDetailRow(
                mobile,
                context.l10n.contributions_view_field_date,
                '${widget.contribution.createdAt.day}/${widget.contribution.createdAt.month}/${widget.contribution.createdAt.year}',
              ),
              const SizedBox(height: 8),
              _buildAvailabilityAccountDropdown(accounts),
              const SizedBox(height: 16),
              buildSectionTitle(context.l10n.contributions_view_section_member),
              Text(
                '${widget.contribution.member.name} (ID: ${widget.contribution.member.memberId})',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.fontText,
                ),
              ),
              const SizedBox(height: 16),
              buildSectionTitle(
                context.l10n.contributions_view_section_financial_concept,
              ),
              Text(
                widget.contribution.financeConcept.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.fontText,
                ),
              ),
              const SizedBox(height: 26),
              buildSectionTitle(
                context.l10n.contributions_view_section_receipt,
              ),
              const SizedBox(height: 26),
              ContentViewer(url: widget.contribution.bankTransferReceipt),
              const SizedBox(height: 46),
              if (_showButton(widget.contribution, store))
                _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  List<AvailabilityAccountModel> _availableAccounts(
    List<AvailabilityAccountModel> accounts,
  ) {
    return accounts
        .where((account) => account.active)
        .where(
          (account) => account.accountType != AccountType.INVESTMENT.apiValue,
        )
        .toList(growable: false);
  }

  Widget _buildAvailabilityAccountDropdown(
    List<AvailabilityAccountModel> accounts,
  ) {
    if (accounts.isEmpty) {
      return Text(
        context.l10n.erp_home_no_availability_accounts,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: AppFonts.fontText,
          color: Colors.redAccent,
        ),
      );
    }

    final initialAccount = accounts.firstWhere(
      (account) =>
          account.availabilityAccountId == _selectedAvailabilityAccountId,
      orElse: () => accounts.first,
    );

    return Dropdown(
      label: context.l10n.accountsReceivable_payment_availability_account_label,
      items: accounts
          .map((account) => account.accountName)
          .toList(growable: false),
      initialValue:
          _selectedAvailabilityAccountId == null
              ? null
              : initialAccount.accountName,
      onChanged: (value) {
        final selectedAccount = accounts.firstWhere(
          (account) => account.accountName == value,
        );
        setState(() {
          _selectedAvailabilityAccountId =
              selectedAccount.availabilityAccountId;
        });
      },
      onValidator: (_) {
        if (_selectedAvailabilityAccountId == null ||
            _selectedAvailabilityAccountId!.isEmpty) {
          return context.l10n.member_contribution_validator_account_required;
        }

        return null;
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMobile(context) ? MainAxisAlignment.center : MainAxisAlignment.end,
      children: [
        ButtonActionTable(
          color: AppColors.blue,
          text: context.l10n.contributions_view_action_approve,
          onPressed: () async {
            final success = await _updateContributionStatus(
              ContributionStatus.PROCESSED,
            );

            if (success && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          icon: Icons.check,
        ),
        ButtonActionTable(
          color: Colors.red,
          text: context.l10n.contributions_view_action_reject,
          onPressed: () async {
            final success = await _updateContributionStatus(
              ContributionStatus.REJECTED,
            );

            if (success && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          icon: Icons.cancel,
        ),
      ],
    );
  }

  bool _showButton(ContributionModel contribution, AuthSessionStore store) {
    return parseContributionStatus(contribution.status) ==
                ContributionStatus.PENDING_VERIFICATION &&
            store.isAdmin() ||
        store.isTreasurer();
  }

  Future<bool> _updateContributionStatus(ContributionStatus status) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (_selectedAvailabilityAccountId == null ||
        _selectedAvailabilityAccountId!.isEmpty) {
      return false;
    }

    if (_isSubmitting) {
      return false;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.contributionPaginationStore.updateStatusContribution(
        widget.contribution.contributionId,
        status,
        _selectedAvailabilityAccountId!,
        _selectedContributionAccount(
          context
              .read<AvailabilityAccountsListStore>()
              .state
              .availabilityAccounts,
        ),
      );
      return true;
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  ContributionAvailabilityAccount _selectedContributionAccount(
    List<AvailabilityAccountModel> accounts,
  ) {
    final selectedAccount = accounts.firstWhere(
      (account) =>
          account.availabilityAccountId == _selectedAvailabilityAccountId,
    );

    return ContributionAvailabilityAccount(
      symbol: selectedAccount.symbol,
      accountName: selectedAccount.accountName,
    );
  }
}
