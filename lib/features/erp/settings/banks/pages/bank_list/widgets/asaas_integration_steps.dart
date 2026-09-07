import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_list/widgets/asaas_contribution_flow_graphic.dart';

class AsaasIntegrationSteps extends StatelessWidget {
  const AsaasIntegrationSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      _AsaasStepData(
        Icons.key_outlined,
        l10n.settings_banks_asaas_step_connect_title,
        l10n.settings_banks_asaas_step_connect_description,
      ),
      _AsaasStepData(
        Icons.volunteer_activism_outlined,
        l10n.settings_banks_asaas_step_contribution_title,
        l10n.settings_banks_asaas_step_contribution_description,
        contributionFlow: true,
      ),
      _AsaasStepData(
        Icons.receipt_long_outlined,
        l10n.settings_banks_asaas_step_reconcile_title,
        l10n.settings_banks_asaas_step_reconcile_description,
        completed: true,
      ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 600;
          if (constraints.maxWidth < 1100) {
            return Column(
              children: List.generate(
                steps.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index == steps.length - 1
                            ? 0
                            : compact
                            ? 20
                            : 24,
                  ),
                  child: _AsaasIntegrationStep(
                    number: index + 1,
                    data: steps[index],
                    isCompact: compact,
                  ),
                ),
              ),
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _AsaasIntegrationStep(number: 1, data: steps[0])),
              const _AsaasStepConnector(),
              Expanded(child: _AsaasIntegrationStep(number: 2, data: steps[1])),
              const _AsaasStepConnector(),
              Expanded(child: _AsaasIntegrationStep(number: 3, data: steps[2])),
            ],
          );
        },
      ),
    );
  }
}

class _AsaasIntegrationStep extends StatelessWidget {
  final int number;
  final _AsaasStepData data;
  final bool isCompact;
  const _AsaasIntegrationStep({
    required this.number,
    required this.data,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isCompact ? 24 : 26,
          height: isCompact ? 24 : 26,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: isCompact ? 16 : 17,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: isCompact ? 18 : 20),
        _icon(),
        SizedBox(height: isCompact ? 18 : 20),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            color: Colors.black,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: AppColors.grey,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _icon() {
    if (data.contributionFlow) {
      return SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: AsaasContributionFlowGraphic(isCompact: isCompact),
        ),
      );
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: isCompact ? 94 : 88,
          height: isCompact ? 94 : 88,
          decoration: BoxDecoration(
            color: (data.completed ? AppColors.green : AppColors.purple)
                .withValues(alpha: data.completed ? 0.1 : 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(data.icon, size: 48, color: AppColors.purple),
        ),
        if (data.completed)
          const Positioned(
            right: 2,
            bottom: 3,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.green,
              child: Icon(Icons.check, size: 20, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _AsaasStepConnector extends StatelessWidget {
  const _AsaasStepConnector();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 76,
    child: Padding(
      padding: const EdgeInsets.only(top: 98),
      child: Row(
        children: [
          const Expanded(
            child: Divider(color: Color(0xFFD9C8F5), thickness: 2),
          ),
          Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5D9F7)),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right,
              color: AppColors.purple,
              size: 24,
            ),
          ),
          const Expanded(
            child: Divider(color: Color(0xFFD9C8F5), thickness: 2),
          ),
        ],
      ),
    ),
  );
}

class _AsaasStepData {
  final IconData icon;
  final String title;
  final String description;
  final bool completed;
  final bool contributionFlow;
  const _AsaasStepData(
    this.icon,
    this.title,
    this.description, {
    this.completed = false,
    this.contributionFlow = false,
  });
}
