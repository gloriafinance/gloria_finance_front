import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_response_model.dart';

class SupportResponseCard extends StatelessWidget {
  const SupportResponseCard({super.key, required this.response});

  final SupportAssistantResponseModel response;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isReportAnalysis = response.intent == 'report_analysis';
    final showRecommendedScreen =
        !isReportAnalysis && response.recommendedScreen.isNotEmpty;
    final stepsTitle =
        isReportAnalysis
            ? l10n.support_assistant_recommended_actions
            : l10n.support_assistant_steps;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SupportResponseBadge(
                text: _localizedIntent(l10n, response.intent),
              ),
              _SupportResponseBadge(
                text:
                    '${l10n.support_assistant_confidence_label}: ${_localizedConfidence(l10n, response.confidence)}',
              ),
            ],
          ),
          if (showRecommendedScreen) ...[
            const SizedBox(height: 16),
            _SupportSectionCard(
              title: l10n.support_assistant_recommended_screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    response.recommendedScreen,
                    style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
                  ),
                  if (response.recommendedRoute.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => context.go(response.recommendedRoute),
                      icon: const Icon(Icons.open_in_new),
                      label: Text(l10n.support_assistant_open_screen),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (response.recommendedConcept.name.isNotEmpty) ...[
            const SizedBox(height: 16),
            _SupportSectionCard(
              title: l10n.support_assistant_recommended_concept,
              child: Text(
                response.recommendedConcept.name,
                style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
              ),
            ),
          ],
          if (response.steps.isNotEmpty) ...[
            const SizedBox(height: 16),
            _SupportSectionCard(
              title: stepsTitle,
              child: Column(
                children: response.steps
                    .map((step) => _SupportStepItem(text: step))
                    .toList(growable: false),
              ),
            ),
          ],
          if (!response.extractedData.isEmpty) ...[
            const SizedBox(height: 16),
            _SupportSectionCard(
              title: l10n.support_assistant_extracted_data,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SupportDataRow(
                    label: l10n.support_assistant_extracted_type,
                    value: response.extractedData.documentType,
                  ),
                  _SupportDataRow(
                    label: l10n.support_assistant_extracted_vendor,
                    value: response.extractedData.vendor,
                  ),
                  _SupportDataRow(
                    label: l10n.support_assistant_extracted_amount,
                    value: response.extractedData.amount,
                  ),
                  _SupportDataRow(
                    label: l10n.support_assistant_extracted_currency,
                    value: response.extractedData.currency,
                  ),
                  _SupportDataRow(
                    label: l10n.support_assistant_extracted_date,
                    value: response.extractedData.documentDate,
                  ),
                  _SupportDataRow(
                    label: l10n.support_assistant_extracted_summary,
                    value: response.extractedData.summary,
                  ),
                ],
              ),
            ),
          ],
          if (response.warnings.isNotEmpty) ...[
            const SizedBox(height: 16),
            _SupportSectionCard(
              title: l10n.support_assistant_warnings,
              accentColor: const Color(0xFFFFF7ED),
              borderColor: const Color(0xFFFED7AA),
              child: Column(
                children: response.warnings
                    .map((warning) => _SupportWarningItem(text: warning))
                    .toList(growable: false),
              ),
            ),
          ],
          if (response.sources.isNotEmpty) ...[
            const SizedBox(height: 14),
            _SupportResponseSources(sources: response.sources),
          ],
        ],
      ),
    );
  }

  String _localizedIntent(dynamic l10n, String intent) {
    switch (intent) {
      case 'product_overview':
        return l10n.support_assistant_intent_product_overview;
      case 'navigation_help':
        return l10n.support_assistant_intent_navigation_help;
      case 'register_financial_movement':
        return l10n.support_assistant_intent_register_financial_movement;
      case 'report_analysis':
        return l10n.support_assistant_intent_report_analysis;
      case 'document_guidance':
        return l10n.support_assistant_intent_document_guidance;
      case 'configuration_help':
        return l10n.support_assistant_intent_configuration_help;
      case 'general_support':
      default:
        return l10n.support_assistant_intent_general_support;
    }
  }

  String _localizedConfidence(dynamic l10n, String confidence) {
    switch (confidence) {
      case 'low':
        return l10n.support_assistant_confidence_low;
      case 'medium':
        return l10n.support_assistant_confidence_medium;
      case 'high':
      default:
        return l10n.support_assistant_confidence_high;
    }
  }
}

class _SupportSectionCard extends StatelessWidget {
  const _SupportSectionCard({
    required this.title,
    required this.child,
    this.accentColor = const Color(0xFFF8FAFC),
    this.borderColor = const Color(0xFFE5E7EB),
  });

  final String title;
  final Widget child;
  final Color accentColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _sectionTitleStyle()),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _SupportResponseBadge extends StatelessWidget {
  const _SupportResponseBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontFamily: AppFonts.fontSubTitle, fontSize: 12),
      ),
    );
  }
}

class _SupportStepItem extends StatelessWidget {
  const _SupportStepItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const Text('• '), Expanded(child: Text(text))],
      ),
    );
  }
}

TextStyle _sectionTitleStyle() {
  return const TextStyle(
    fontFamily: AppFonts.fontTitle,
    fontSize: 15,
    color: Colors.black87,
  );
}

class _SupportWarningItem extends StatelessWidget {
  const _SupportWarningItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _SupportDataRow extends StatelessWidget {
  const _SupportDataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _SupportResponseSources extends StatelessWidget {
  const _SupportResponseSources({required this.sources});

  final List<String> sources;

  @override
  Widget build(BuildContext context) {
    final labels = <String>[];

    if (sources.any((source) => source.startsWith('screen:'))) {
      labels.add(_localizedSourceLabel(context, 'screen'));
    }
    if (sources.any((source) => source.startsWith('guide:'))) {
      labels.add(_localizedSourceLabel(context, 'guide'));
    }
    if (sources.any((source) => source.startsWith('rule:'))) {
      labels.add(_localizedSourceLabel(context, 'rule'));
    }
    if (sources.any((source) => source.startsWith('report:'))) {
      labels.add(_localizedSourceLabel(context, 'report'));
    }
    if (sources.any((source) => source.startsWith('concept-rule:'))) {
      labels.add(_localizedSourceLabel(context, 'concept-rule'));
    }
    if (sources.any((source) => source.startsWith('concept:'))) {
      labels.add(_localizedSourceLabel(context, 'concept'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.verified_outlined,
              size: 14,
              color: Colors.black45,
            ),
            const SizedBox(width: 6),
            Text(
              _sourcesCaption(context),
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: labels
              .take(2)
              .map((label) => _SupportSourceBadge(text: label))
              .toList(growable: false),
        ),
      ],
    );
  }

  String _sourcesCaption(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'es':
        return 'Basado en';
      case 'en':
        return 'Based on';
      case 'pt':
      default:
        return 'Baseado em';
    }
  }

  String _localizedSourceLabel(BuildContext context, String sourceType) {
    final languageCode = Localizations.localeOf(context).languageCode;

    switch (languageCode) {
      case 'es':
        return switch (sourceType) {
          'screen' => 'pantalla actual',
          'guide' => 'flujo del sistema',
          'rule' => 'reglas operativas',
          'report' => 'reporte emitido',
          'concept-rule' => 'reglas de conceptos',
          'concept' => 'conceptos configurados',
          _ => 'contexto del sistema',
        };
      case 'en':
        return switch (sourceType) {
          'screen' => 'current screen',
          'guide' => 'system flow',
          'rule' => 'operational rules',
          'report' => 'generated report',
          'concept-rule' => 'concept rules',
          'concept' => 'configured concepts',
          _ => 'system context',
        };
      case 'pt':
      default:
        return switch (sourceType) {
          'screen' => 'tela atual',
          'guide' => 'fluxo do sistema',
          'rule' => 'regras operacionais',
          'report' => 'relatório emitido',
          'concept-rule' => 'regras de conceitos',
          'concept' => 'conceitos configurados',
          _ => 'contexto do sistema',
        };
    }
  }
}

class _SupportSourceBadge extends StatelessWidget {
  const _SupportSourceBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 11,
          color: Colors.black54,
        ),
      ),
    );
  }
}
