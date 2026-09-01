import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';

class AsaasConnectionHero extends StatelessWidget {
  final VoidCallback onShowHowItWorks;
  final VoidCallback? onConnectAsaas;

  const AsaasConnectionHero({
    super.key,
    required this.onShowHowItWorks,
    this.onConnectAsaas,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1024;
        final content = _HeroContent(
          onShowHowItWorks: onShowHowItWorks,
          onConnectAsaas: onConnectAsaas,
        );
        final illustration = const AspectRatio(
          aspectRatio: 3 / 2,
          child: Image(
            image: AssetImage('images/integrations/asaas_connection_hero.png'),
            fit: BoxFit.contain,
          ),
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(desktop ? 28 : 20),
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.025),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.purple.withValues(alpha: 0.24)),
          ),
          child:
              desktop
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: content),
                      const SizedBox(width: 24),
                      Expanded(flex: 4, child: illustration),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      content,
                      const SizedBox(height: 20),
                      illustration,
                    ],
                  ),
        );
      },
    );
  }
}

class _HeroContent extends StatelessWidget {
  final VoidCallback onShowHowItWorks;
  final VoidCallback? onConnectAsaas;

  const _HeroContent({
    required this.onShowHowItWorks,
    required this.onConnectAsaas,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RecommendedBadge(label: l10n.settings_banks_asaas_recommended),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: l10n.settings_banks_asaas_hero_title_prefix),
              TextSpan(
                text: l10n.settings_banks_asaas_provider_name,
                style: const TextStyle(color: AppColors.purple),
              ),
            ],
          ),
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.settings_banks_asaas_hero_description,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 15,
            color: AppColors.grey,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        _BenefitsList(),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (onConnectAsaas != null)
              CustomButton(
                text: l10n.settings_banks_asaas_connect_now,
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                onPressed: onConnectAsaas,
                icon: Icons.link,
              ),
            CustomButton(
              text: l10n.settings_banks_asaas_how_it_works,
              backgroundColor: AppColors.purple,
              typeButton: CustomButton.outline,
              textColor: AppColors.purple,
              onPressed: onShowHowItWorks,
              icon: Icons.info_outline,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.shield_outlined, size: 18, color: AppColors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.settings_banks_asaas_security_footer,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  final String label;

  const _RecommendedBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_outline, size: 15, color: AppColors.mustard),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 11,
              color: AppColors.purple,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final benefits = [
      (
        l10n.settings_banks_asaas_benefit_pix_title,
        l10n.settings_banks_asaas_benefit_pix_description,
      ),
      (
        l10n.settings_banks_asaas_benefit_sync_title,
        l10n.settings_banks_asaas_benefit_sync_description,
      ),
      (
        l10n.settings_banks_asaas_benefit_import_title,
        l10n.settings_banks_asaas_benefit_import_description,
      ),
      (
        l10n.settings_banks_asaas_benefit_webhooks_title,
        l10n.settings_banks_asaas_benefit_webhooks_description,
      ),
    ];

    return Column(
      children: benefits
          .map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _BenefitItem(title: benefit.$1, description: benefit.$2),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String title;
  final String description;

  const _BenefitItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.check_circle, size: 18, color: AppColors.green),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 12,
                  color: AppColors.grey,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
