import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/general.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'widgets/bank_table.dart';
import 'widgets/asaas_connection_hero.dart';
import 'widgets/asaas_how_it_works_dialog.dart';

class BankListScreen extends StatefulWidget {
  final bool showAsaasConnection;
  final VoidCallback? onConnectAsaas;

  const BankListScreen({
    super.key,
    required this.showAsaasConnection,
    this.onConnectAsaas,
  });

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<BankStore>();
      if (!store.state.isLoading && store.state.banks.isEmpty) {
        store.searchBanks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader(context),
        const SizedBox(height: 24),
        if (widget.showAsaasConnection) ...[
          AsaasConnectionHero(
            onShowHowItWorks: () => _showHowItWorks(context),
            onConnectAsaas: widget.onConnectAsaas,
          ),
          const SizedBox(height: 24),
        ],
        _bankTableHeader(context),
        const SizedBox(height: 16),
        const BankTable(),
      ],
    );
  }

  Widget _pageHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.settings_banks_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.settings_banks_subtitle,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _bankTableHeader(BuildContext context) {
    final addBankButton = ButtonActionTable(
      color: AppColors.purple,
      text: context.l10n.settings_banks_new_bank,
      onPressed: () => GoRouter.of(context).go('/banks/add'),
      icon: Icons.add_box_outlined,
    );

    if (!widget.showAsaasConnection) {
      return Align(alignment: Alignment.centerRight, child: addBankButton);
    }

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.settings_banks_connected_accounts_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.settings_banks_connected_accounts_subtitle,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
      ],
    );
    if (isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, const SizedBox(height: 12), addBankButton],
      );
    }

    return Row(children: [Expanded(child: header), addBankButton]);
  }

  void _showHowItWorks(BuildContext context) {
    showDialog<void>(
      context: context,
      builder:
          (dialogContext) =>
              AsaasHowItWorksDialog(onConnectAsaas: widget.onConnectAsaas),
    );
  }
}
