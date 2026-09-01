import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/asaas_connection/state/asaas_connection_state.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/asaas_connection_store.dart';
import 'widgets/asaas_connection_confirmation.dart';
import 'widgets/asaas_connection_form.dart';

class AsaasConnectionScreen extends StatelessWidget {
  const AsaasConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => AsaasConnectionStore(),
      child: const _AsaasConnectionContent(),
    );
  }
}

class _AsaasConnectionContent extends StatelessWidget {
  const _AsaasConnectionContent();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AsaasConnectionStore>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(onBack: () => context.go('/banks')),
        const SizedBox(height: 28),
        if (state.step == AsaasConnectionStep.form)
          AsaasConnectionForm(onBack: () => context.go('/banks'))
        else if (state.connection != null)
          AsaasConnectionConfirmation(
            connection: state.connection!,
            onFinish: () => context.go('/banks'),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          tooltip: context.l10n.settings_banks_asaas_connect_back,
          icon: const Icon(Icons.arrow_back, color: AppColors.purple),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            context.l10n.settings_banks_asaas_connect_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 26,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
