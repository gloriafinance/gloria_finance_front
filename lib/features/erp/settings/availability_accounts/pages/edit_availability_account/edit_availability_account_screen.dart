import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/edit_availability_account/store/availability_account_edit_store.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/widgets/view_availabilityAccount_account.dart';

class EditAvailabilityAccountScreen extends StatelessWidget {
  final String availabilityAccountId;
  final AvailabilityAccountModel? initialAccount;

  const EditAvailabilityAccountScreen({
    super.key,
    required this.availabilityAccountId,
    this.initialAccount,
  });

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    final store = context.watch<AvailabilityAccountsListStore>();
    final account =
        initialAccount ??
        store.findByAvailabilityAccountId(availabilityAccountId);

    if (account == null) {
      if (store.state.makeRequest) {
        return _loading(context);
      }
      return _notFound(context);
    }

    return ChangeNotifierProvider(
      create: (_) => AvailabilityAccountEditStore(account: account),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go('/availability-accounts'),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.settings_availability_form_title_edit,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _EditAvailabilityAccountBody(account: account),
        ],
      ),
    );
  }

  Widget _notFound(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(context.l10n.common_no_results_found),
    );
  }

  Widget _loading(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: const Center(child: Loading()),
    );
  }
}

class _EditAvailabilityAccountBody extends StatefulWidget {
  final AvailabilityAccountModel account;

  const _EditAvailabilityAccountBody({required this.account});

  @override
  State<_EditAvailabilityAccountBody> createState() =>
      _EditAvailabilityAccountBodyState();
}

class _EditAvailabilityAccountBodyState
    extends State<_EditAvailabilityAccountBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final store = context.watch<AvailabilityAccountEditStore>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewAvailabilityAccount(account: widget.account, showActions: false),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(17, 24, 39, 0.06),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.settings_availability_form_edit_section_title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Input(
                    label: context.l10n.settings_availability_field_name,
                    initialValue: store.state.accountName,
                    onChanged: store.setAccountName,
                    onValidator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.validation_required;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(context.l10n.settings_availability_field_active),
                      Switch(
                        value: store.state.active,
                        onChanged: store.setActive,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment:
                        mobile ? Alignment.center : Alignment.centerRight,
                    child: SizedBox(
                      width: mobile ? double.infinity : 240,
                      child: _saveButton(context, store),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton(BuildContext context, AvailabilityAccountEditStore store) {
    if (store.state.makeRequest) {
      return const Loading();
    }

    return CustomButton(
      text: context.l10n.settings_availability_update,
      backgroundColor: AppColors.green,
      textColor: Colors.black,
      onPressed: () => _save(context, store),
    );
  }

  Future<void> _save(
    BuildContext context,
    AvailabilityAccountEditStore store,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final router = GoRouter.of(context);
    final availabilityAccountsListStore =
        context.read<AvailabilityAccountsListStore>();
    final l10n = context.l10n;
    final success = await store.send();
    if (!mounted) return;

    if (!success) {
      return;
    }

    Toast.showMessage(l10n.settings_availability_toast_updated, ToastType.info);
    await availabilityAccountsListStore.searchAvailabilityAccounts();
    if (!mounted) return;
    router.go('/availability-accounts');
  }
}
