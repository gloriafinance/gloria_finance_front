import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_assistance_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/pages/form_financial_concept/store/financial_concept_form_store.dart';
import 'package:go_router/go_router.dart';

class FinancialConceptAIAssistant extends StatefulWidget {
  final FinancialConceptFormStore formStore;
  final VoidCallback? onOpenConceptList;

  const FinancialConceptAIAssistant({
    super.key,
    required this.formStore,
    this.onOpenConceptList,
  });

  @override
  State<FinancialConceptAIAssistant> createState() =>
      _FinancialConceptAIAssistantState();
}

class _FinancialConceptAIAssistantState
    extends State<FinancialConceptAIAssistant> {
  bool _showDetails = false;

  @override
  void didUpdateWidget(covariant FinancialConceptAIAssistant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.formStore.assistanceResponse != widget.formStore.assistanceResponse) {
      _showDetails = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formStore = widget.formStore;
    if (formStore.state.isEdit) return const SizedBox.shrink();

    final suggestion = formStore.assistanceResponse;
    final mobile = isMobile(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyMiddle),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mobile) ...[
            Row(
              children: [
                const Icon(Icons.smart_toy_outlined, color: AppColors.purple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.settings_financial_concept_ai_title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (formStore.requestingAssistance)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.purple,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (!formStore.requestingAssistance)
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: context.l10n.settings_financial_concept_ai_button,
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  leading: const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: Colors.white,
                  ),
                  onPressed: () => _openAssistantModal(formStore),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
          ] else ...[
            Row(
              children: [
                const Icon(Icons.smart_toy_outlined, color: AppColors.purple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.settings_financial_concept_ai_title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                formStore.requestingAssistance
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.purple,
                      ),
                    )
                    : SizedBox(
                      width: 250,
                      child: CustomButton(
                        text: context.l10n.settings_financial_concept_ai_button,
                        backgroundColor: AppColors.purple,
                        textColor: Colors.white,
                        leading: const Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Colors.white,
                        ),
                        onPressed: () => _openAssistantModal(formStore),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                    ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Text(
            context.l10n.settings_financial_concept_ai_description,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: AppColors.grey,
            ),
          ),
          if (suggestion != null) ...[
            const SizedBox(height: 14),
            _buildAssistanceResult(context, suggestion),
          ],
        ],
      ),
    );
  }

  Widget _buildAssistanceResult(
    BuildContext context,
    FinancialConceptAssistanceModel suggestion,
  ) {
    final saveBlocked = !suggestion.needsCreate;
    final cardColor =
        saveBlocked
            ? const Color.fromRGBO(255, 236, 217, 1)
            : const Color.fromRGBO(231, 245, 255, 1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              saveBlocked ? const Color(0xFFF2B27D) : const Color(0xFF90CAF9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            saveBlocked
                ? context.l10n.settings_financial_concept_ai_result_existing
                : context.l10n.settings_financial_concept_ai_result_applied,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _resolveBannerCopy(context, suggestion),
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12.5,
              color: Colors.black87,
            ),
            maxLines: isMobile(context) ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => setState(() => _showDetails = !_showDetails),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              context.l10n.settings_financial_concept_ai_details_action,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12.5,
                color: AppColors.purple,
              ),
            ),
          ),
          if (_showDetails) ...[
            const SizedBox(height: 8),
            _buildDetailsSection(context, suggestion),
          ],
          if (saveBlocked) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomButton(
                text:
                    context.l10n.settings_financial_concept_ai_existing_action,
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                onPressed: () {
                  if (widget.onOpenConceptList != null) {
                    widget.onOpenConceptList!.call();
                    return;
                  }
                  context.go('/financial-concepts');
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsSection(
    BuildContext context,
    FinancialConceptAssistanceModel suggestion,
  ) {
    final typeLabel = _resolveTypeLabel(suggestion.concept.type);
    final categoryLabel = _resolveCategoryLabel(suggestion.concept.statementCategory);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${suggestion.concept.name} • $typeLabel',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            categoryLabel,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            suggestion.justification,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _resolveBannerCopy(
    BuildContext context,
    FinancialConceptAssistanceModel suggestion,
  ) {
    if (!suggestion.needsCreate) {
      return context.l10n.settings_financial_concept_ai_result_existing;
    }

    final typeLabel = _resolveTypeLabel(suggestion.concept.type);
    final categoryLabel = _resolveCategoryLabel(suggestion.concept.statementCategory);
    final hasTypeAndCategory = typeLabel.trim().isNotEmpty && categoryLabel.trim().isNotEmpty;
    final shouldUseAssistantTone = suggestion.justification.trim().length > 260;

    if (shouldUseAssistantTone) {
      return context.l10n.settings_financial_concept_ai_result_assistant_tone;
    }

    if (hasTypeAndCategory) {
      return context.l10n.settings_financial_concept_ai_result_applied_summary(
        typeLabel,
        categoryLabel,
      );
    }

    return context.l10n.settings_financial_concept_ai_result_applied;
  }

  String _resolveTypeLabel(String apiValue) {
    try {
      return getFriendlyNameFinancialConceptType(apiValue);
    } catch (_) {
      return apiValue;
    }
  }

  String _resolveCategoryLabel(String apiValue) {
    try {
      return getFriendlyNameStatementCategory(apiValue);
    } catch (_) {
      return apiValue;
    }
  }

  Future<void> _openAssistantModal(FinancialConceptFormStore formStore) async {
    final response = await ModalPage(
      title: context.l10n.settings_financial_concept_ai_modal_title,
      width: 560,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: _FinancialConceptAssistantPrompt(
          maxLength: FinancialConceptFormStore.maxAssistanceContextLength,
          onSubmit: (contextInput) async {
            final normalized = contextInput.trim();

            if (normalized.isEmpty) {
              Toast.showMessage(
                context.l10n.settings_financial_concept_ai_error_required,
                ToastType.warning,
              );
              return null;
            }

            if (normalized.length >
                FinancialConceptFormStore.maxAssistanceContextLength) {
              Toast.showMessage(
                context.l10n.settings_financial_concept_ai_error_max_chars(
                  FinancialConceptFormStore.maxAssistanceContextLength,
                ),
                ToastType.warning,
              );
              return null;
            }

            return formStore.requestAssistance(normalized);
          },
        ),
      ),
    ).show<FinancialConceptAssistanceModel>(context);

    if (!mounted) return;

    if (response == null) {
      Toast.showMessage(
        context.l10n.settings_financial_concept_ai_toast_error,
        ToastType.warning,
      );
      return;
    }

    final message =
        response.needsCreate
            ? context.l10n.settings_financial_concept_ai_toast_applied
            : context.l10n.settings_financial_concept_ai_toast_existing;
    Toast.showMessage(message, ToastType.info);
  }
}

class _FinancialConceptAssistantPrompt extends StatefulWidget {
  final int maxLength;
  final Future<FinancialConceptAssistanceModel?> Function(String contextInput)
  onSubmit;

  const _FinancialConceptAssistantPrompt({
    required this.maxLength,
    required this.onSubmit,
  });

  @override
  State<_FinancialConceptAssistantPrompt> createState() =>
      _FinancialConceptAssistantPromptState();
}

class _FinancialConceptAssistantPromptState
    extends State<_FinancialConceptAssistantPrompt> {
  String _contextValue = '';
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        _contextValue.trim().isNotEmpty &&
        _contextValue.length <= widget.maxLength &&
        !_submitting;

    return PopScope(
      canPop: !_submitting,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.settings_financial_concept_ai_modal_description,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Input(
            label:
                context.l10n.settings_financial_concept_ai_modal_context_label,
            maxLines: 4,
            initialValue: '',
            onChanged: (value) => setState(() => _contextValue = value),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_contextValue.length}/${widget.maxLength}',
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ),
          if (_submitting) ...[
            const SizedBox(height: 12),
            const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: AppColors.purple,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: context.l10n.settings_financial_concept_ai_modal_cancel,
                  backgroundColor: AppColors.greyMiddle,
                  textColor: Colors.black87,
                  onPressed:
                      _submitting ? null : () => Navigator.of(context).pop(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: CustomButton(
                  text: context.l10n.settings_financial_concept_ai_modal_submit,
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  onPressed: canSubmit ? _handleSubmit : null,
                  leading: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 16,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_submitting) return;

    setState(() => _submitting = true);
    final response = await widget.onSubmit(_contextValue);

    if (!mounted) return;

    setState(() => _submitting = false);
    if (response == null) return;

    Navigator.of(context).pop(response);
  }
}
