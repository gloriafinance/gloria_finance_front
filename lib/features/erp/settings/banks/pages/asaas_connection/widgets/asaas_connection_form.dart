import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/asaas_connection/store/asaas_connection_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AsaasConnectionForm extends StatefulWidget {
  final VoidCallback onBack;

  const AsaasConnectionForm({super.key, required this.onBack});

  @override
  State<AsaasConnectionForm> createState() => _AsaasConnectionFormState();
}

class _AsaasConnectionFormState extends State<AsaasConnectionForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isApiKeyVisible = false;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AsaasConnectionStore>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        final form = _FormCard(
          formKey: _formKey,
          connectionName: store.state.connectionName,
          apiKey: store.state.apiKey,
          isApiKeyVisible: _isApiKeyVisible,
          isSubmitting: store.state.makeRequest,
          onConnectionNameChanged: store.setConnectionName,
          onApiKeyChanged: store.setApiKey,
          onToggleVisibility: () {
            setState(() => _isApiKeyVisible = !_isApiKeyVisible);
          },
          onBack: widget.onBack,
          onSubmit: () => _submit(store),
        );
        const guidance = _ConnectionSidebar();

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [form, const SizedBox(height: 20), guidance],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: form),
            const SizedBox(width: 24),
            const Expanded(flex: 1, child: guidance),
          ],
        );
      },
    );
  }

  Future<void> _submit(AsaasConnectionStore store) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await store.connect();
  }
}

class _FormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String connectionName;
  final String apiKey;
  final bool isApiKeyVisible;
  final bool isSubmitting;
  final ValueChanged<String> onConnectionNameChanged;
  final ValueChanged<String> onApiKeyChanged;
  final VoidCallback onToggleVisibility;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const _FormCard({
    required this.formKey,
    required this.connectionName,
    required this.apiKey,
    required this.isApiKeyVisible,
    required this.isSubmitting,
    required this.onConnectionNameChanged,
    required this.onApiKeyChanged,
    required this.onToggleVisibility,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final title = Text(
                  l10n.settings_banks_asaas_connect_form_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                );
                const logo = Image(
                  image: AssetImage('images/integrations/asaas_wordmark.png'),
                  width: 150,
                  fit: BoxFit.contain,
                );

                if (constraints.maxWidth < 440) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [title, const SizedBox(height: 10), logo],
                  );
                }

                return Row(children: [Expanded(child: title), logo]);
              },
            ),
            const SizedBox(height: 10),
            Text(
              l10n.settings_banks_asaas_connect_form_subtitle,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 15,
                color: Colors.black54,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            _InstructionNotice(
              text: l10n.settings_banks_asaas_connect_key_location,
            ),
            Input(
              label: l10n.settings_banks_asaas_connect_connection_name_label,
              initialValue:
                  connectionName.isEmpty
                      ? l10n
                          .settings_banks_asaas_connect_connection_name_default
                      : connectionName,
              onChanged: onConnectionNameChanged,
            ),
            Input(
              label: l10n.settings_banks_asaas_connect_api_key_label,
              initialValue: apiKey,
              onChanged: onApiKeyChanged,
              isPass: !isApiKeyVisible,
              iconRight: Icon(
                isApiKeyVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.purple,
              ),
              onIconTap: onToggleVisibility,
              onValidator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.settings_banks_asaas_connect_api_key_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _SecurityNotice(text: l10n.settings_banks_asaas_connect_security),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final actions = [
                  CustomButton(
                    text: l10n.settings_banks_asaas_connect_back,
                    backgroundColor: AppColors.purple,
                    typeButton: CustomButton.outline,
                    textColor: AppColors.purple,
                    onPressed: isSubmitting ? null : onBack,
                  ),
                  CustomButton(
                    text:
                        isSubmitting
                            ? l10n.settings_banks_asaas_connect_connecting
                            : l10n.settings_banks_asaas_connect_submit,
                    backgroundColor: AppColors.purple,
                    textColor: Colors.white,
                    icon: isSubmitting ? null : Icons.arrow_forward,
                    onPressed: isSubmitting ? null : onSubmit,
                  ),
                ];
                if (constraints.maxWidth < 480) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      actions[1],
                      const SizedBox(height: 12),
                      actions[0],
                    ],
                  );
                }
                return Row(children: [actions[0], const Spacer(), actions[1]]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionNotice extends StatelessWidget {
  final String text;

  const _InstructionNotice({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.purple),
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

class _SecurityNotice extends StatelessWidget {
  final String text;

  const _SecurityNotice({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 13,
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

class _ConnectionGuidance extends StatelessWidget {
  const _ConnectionGuidance();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      l10n.settings_banks_asaas_connect_guidance_enabled,
      l10n.settings_banks_asaas_connect_guidance_permissions,
      l10n.settings_banks_asaas_connect_guidance_private,
      l10n.settings_banks_asaas_connect_guidance_revoke,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.settings_banks_asaas_connect_guidance_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
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

class _ConnectionSidebar extends StatelessWidget {
  const _ConnectionSidebar();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_ConnectionGuidance(), SizedBox(height: 20), _HelpCard()],
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: AppColors.purple, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.settings_banks_asaas_connect_help_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 18,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.settings_banks_asaas_connect_help_description,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: Colors.black54,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  () => launchUrl(
                    Uri.parse('https://www.asaas.com/'),
                    mode: LaunchMode.externalApplication,
                  ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(
                l10n.settings_banks_asaas_connect_help_action.toUpperCase(),
                style: const TextStyle(fontFamily: AppFonts.fontTitle),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.purple,
                side: const BorderSide(color: AppColors.purple),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
