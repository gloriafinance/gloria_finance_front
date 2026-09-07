import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/asaas_connection_model.dart';

class AsaasConnectionConfirmation extends StatelessWidget {
  final AsaasConnectionModel connection;
  final VoidCallback onFinish;

  const AsaasConnectionConfirmation({
    super.key,
    required this.connection,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        final confirmation = _ConfirmationCard(connection: connection);
        const nextSteps = _NextStepsCard();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: confirmation),
                  const SizedBox(width: 24),
                  const Expanded(flex: 1, child: nextSteps),
                ],
              )
            else ...[
              confirmation,
              const SizedBox(height: 20),
              nextSteps,
            ],
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: CustomButton(
                text: context.l10n.settings_banks_asaas_connect_finish,
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                icon: Icons.arrow_forward,
                onPressed: onFinish,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ConfirmationCard extends StatelessWidget {
  final AsaasConnectionModel connection;

  const _ConfirmationCard({required this.connection});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 56,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.settings_banks_asaas_connect_success_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              l10n.settings_banks_asaas_connect_success_description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 15,
                color: Colors.black54,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _ConnectionStatus(connection: connection),
          const SizedBox(height: 16),
          _SuccessNotice(
            text: l10n.settings_banks_asaas_connect_success_notice,
          ),
        ],
      ),
    );
  }
}

class _ConnectionStatus extends StatelessWidget {
  final AsaasConnectionModel connection;

  const _ConnectionStatus({required this.connection});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status =
        connection.status == 'ACTIVE'
            ? l10n.settings_banks_asaas_connect_status_value_active
            : connection.status;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 560),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.settings_banks_asaas_connect_status_active,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 12,
                color: AppColors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessNotice extends StatelessWidget {
  final String text;

  const _SuccessNotice({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 560),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_outlined, color: AppColors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStepsCard extends StatelessWidget {
  const _NextStepsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      l10n.settings_banks_asaas_connect_next_sync,
      l10n.settings_banks_asaas_connect_next_webhooks,
      l10n.settings_banks_asaas_connect_next_receipts,
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settings_banks_asaas_connect_next_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 22),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.green,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.35,
                      ),
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
}
