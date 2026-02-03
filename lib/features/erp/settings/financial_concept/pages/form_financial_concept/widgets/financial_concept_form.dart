import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/pages/form_financial_concept/store/financial_concept_form_store.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:church_finance_bk/features/erp/widgets/statement_category_help.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FinancialConceptForm extends StatefulWidget {
  const FinancialConceptForm({super.key});

  @override
  State<FinancialConceptForm> createState() => _FinancialConceptFormState();
}

class _FinancialConceptFormState extends State<FinancialConceptForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formStore = context.watch<FinancialConceptFormStore>();

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child:
            isMobile(context)
                ? _buildMobileLayout(context, formStore)
                : _buildDesktopLayout(context, formStore),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    FinancialConceptFormStore formStore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameField(formStore),
        _buildDescriptionField(formStore),
        _buildTypeField(formStore),
        _buildStatementCategoryField(context, formStore),
        const SizedBox(height: 16),
        _buildIndicatorsSection(context, formStore),
        const SizedBox(height: 16),
        _buildActiveToggle(formStore),
        const SizedBox(height: 24),
        _buildSubmitButton(formStore),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    FinancialConceptFormStore formStore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildNameField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildTypeField(formStore)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDescriptionField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildStatementCategoryField(context, formStore)),
          ],
        ),
        const SizedBox(height: 16),
        _buildIndicatorsSection(context, formStore),
        const SizedBox(height: 16),
        _buildActiveToggle(formStore),
        const SizedBox(height: 24),
        _buildSubmitButton(formStore),
      ],
    );
  }

  Widget _buildNameField(FinancialConceptFormStore formStore) {
    return Input(
      label: context.l10n.settings_financial_concept_field_name,
      initialValue: formStore.state.name,
      onValidator: _requiredValidator,
      onChanged: formStore.setName,
    );
  }

  Widget _buildDescriptionField(FinancialConceptFormStore formStore) {
    return Input(
      label: context.l10n.settings_financial_concept_field_description,
      initialValue: formStore.state.description,
      onValidator: _requiredValidator,
      onChanged: formStore.setDescription,
    );
  }

  Widget _buildTypeField(FinancialConceptFormStore formStore) {
    return Dropdown(
      label: context.l10n.settings_financial_concept_field_type,
      initialValue: formStore.state.type?.friendlyName,
      items: FinancialConceptTypeExtension.listFriendlyName,
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.settings_financial_concept_error_select_type;
        }
        return null;
      },
      onChanged: (value) {
        final selected = FinancialConceptType.values.firstWhere(
          (element) => element.friendlyName == value,
        );
        formStore.setType(selected);
      },
    );
  }

  Widget _buildStatementCategoryField(
    BuildContext context,
    FinancialConceptFormStore formStore,
  ) {
    return Dropdown(
      label: context.l10n.settings_financial_concept_field_statement_category,
      labelSuffix: _buildStatementCategoryHelpIcon(context),
      initialValue: formStore.state.statementCategory?.friendlyName,
      items: StatementCategoryExtension.listFriendlyName,
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.settings_financial_concept_error_select_category;
        }
        return null;
      },
      onChanged: (value) {
        final selected = StatementCategoryExtension.fromFriendlyName(value);
        formStore.setStatementCategory(selected);
      },
    );
  }

  Widget _buildActiveToggle(FinancialConceptFormStore formStore) {
    return Row(
      children: [
        Text(
          context.l10n.settings_financial_concept_field_active,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          activeColor: AppColors.purple,
          value: formStore.state.active,
          onChanged: formStore.setActive,
        ),
      ],
    );
  }

  Widget _buildIndicatorsSection(
    BuildContext context,
    FinancialConceptFormStore formStore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.settings_financial_concept_indicators_title,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: context.l10n.settings_financial_concept_help_indicators,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showIndicatorsHelp(context),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.help_outline,
                    size: 18,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _buildIndicatorToggle(
              label:
                  context.l10n.settings_financial_concept_indicator_cash_flow,
              value: formStore.state.affectsCashFlow,
              onChanged: formStore.setAffectsCashFlow,
            ),
            _buildIndicatorToggle(
              label: context.l10n.settings_financial_concept_indicator_result,
              value: formStore.state.affectsResult,
              onChanged: formStore.setAffectsResult,
            ),
            _buildIndicatorToggle(
              label: context.l10n.settings_financial_concept_indicator_balance,
              value: formStore.state.affectsBalance,
              onChanged: formStore.setAffectsBalance,
            ),
            _buildIndicatorToggle(
              label:
                  context.l10n.settings_financial_concept_indicator_operational,
              value: formStore.state.isOperational,
              onChanged: formStore.setIsOperational,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicatorToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            activeColor: AppColors.purple,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(FinancialConceptFormStore formStore) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 220,
        child:
            formStore.state.makeRequest
                ? const Loading()
                : CustomButton(
                  text: context.l10n.settings_financial_concept_save,
                  backgroundColor: AppColors.green,
                  textColor: Colors.black,
                  onPressed: () => _save(formStore),
                ),
      ),
    );
  }

  Widget _buildStatementCategoryHelpIcon(BuildContext context) {
    return StatementCategoryHelpButton(
      dialogTitle: context.l10n.settings_financial_concept_help_statement_title,
      entries: [
        StatementCategoryHelpEntry(
          code: StatementCategory.COGS.apiValue,
          title: StatementCategory.COGS.friendlyName,
          body: context.l10n.reports_income_category_help_cogs_body,
        ),
        StatementCategoryHelpEntry(
          code: StatementCategory.REVENUE.apiValue,
          title: StatementCategory.REVENUE.friendlyName,
          body: context.l10n.reports_income_category_help_revenue_body,
        ),
        StatementCategoryHelpEntry(
          code: StatementCategory.OPEX.apiValue,
          title: StatementCategory.OPEX.friendlyName,
          body: context.l10n.reports_income_category_help_opex_body,
        ),
        StatementCategoryHelpEntry(
          code: StatementCategory.CAPEX.apiValue,
          title: StatementCategory.CAPEX.friendlyName,
          body: context.l10n.reports_income_category_help_capex_body,
        ),
        StatementCategoryHelpEntry(
          code: StatementCategory.OTHER.apiValue,
          title: StatementCategory.OTHER.friendlyName,
          body: context.l10n.reports_income_category_help_other_body,
        ),
      ],
      closeText: context.l10n.settings_financial_concept_help_understood,
      tooltipMessage:
          context.l10n.settings_financial_concept_help_statement_categories,
      backgroundColor: const Color.fromRGBO(243, 205, 51, 0.51),
      iconColor: Colors.black87,
      iconSize: 14,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.settings_financial_concept_error_required;
    }
    return null;
  }

  Future<void> _save(FinancialConceptFormStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final success = await formStore.submit();

    if (success && mounted) {
      Toast.showMessage(
        context.l10n.settings_financial_concept_toast_saved,
        ToastType.info,
      );
      final conceptStore = context.read<FinancialConceptStore>();
      await conceptStore.searchFinancialConcepts();
      context.go('/financial-concepts');
    }
  }

  void _showIndicatorsHelp(BuildContext context) {
    ModalPage(
      title: context.l10n.settings_financial_concept_help_indicators,
      body: const _IndicatorsHelpContent(),
      width: 540,
    ).show(context);
  }
}

class _IndicatorsHelpContent extends StatelessWidget {
  const _IndicatorsHelpContent();

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title':
            context
                .l10n
                .settings_financial_concept_help_indicator_cash_flow_title,
        'description':
            context
                .l10n
                .settings_financial_concept_help_indicator_cash_flow_desc,
      },
      {
        'title':
            context.l10n.settings_financial_concept_help_indicator_result_title,
        'description':
            context.l10n.settings_financial_concept_help_indicator_result_desc,
      },
      {
        'title':
            context
                .l10n
                .settings_financial_concept_help_indicator_balance_title,
        'description':
            context.l10n.settings_financial_concept_help_indicator_balance_desc,
      },
      {
        'title':
            context
                .l10n
                .settings_financial_concept_help_indicator_operational_title,
        'description':
            context
                .l10n
                .settings_financial_concept_help_indicator_operational_desc,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.settings_financial_concept_help_indicator_intro,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 15,
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['description']!,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
