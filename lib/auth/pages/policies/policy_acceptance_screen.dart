import 'package:church_finance_bk/auth/models/policy_config.dart';
import 'package:church_finance_bk/auth/pages/login/store/auth_session_store.dart';
import 'package:church_finance_bk/auth/pages/policies/store/policy_acceptance_store.dart';
import 'package:church_finance_bk/auth/widgets/layout_auth.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/app_logo.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyAcceptanceScreen extends StatelessWidget {
  const PolicyAcceptanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PolicyAcceptanceStore(),
      child: const _PolicyAcceptanceContent(),
    );
  }
}

class _PolicyAcceptanceContent extends StatelessWidget {
  const _PolicyAcceptanceContent();

  @override
  Widget build(BuildContext context) {
    return LayoutAuth(
      height: 680,
      width: 550,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: ApplicationLogo(height: 80),
              ),
              const SizedBox(height: 24),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 32),
              _buildPolicyCheckboxes(context),
              const SizedBox(height: 32),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Antes de continuar, revise e aceite as políticas do Glória Finance',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: AppColors.purple,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações importantes:',
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '• A igreja e o Glória Finance tratam dados pessoais e dados sensíveis para o funcionamento do sistema.\n\n'
            '• Em conformidade com a Lei Geral de Proteção de Dados (LGPD), é necessário que você aceite as políticas abaixo para continuar utilizando a plataforma.\n\n'
            '• Clique nos links para ler os textos completos antes de aceitar.',
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.black,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCheckboxes(BuildContext context) {
    final store = Provider.of<PolicyAcceptanceStore>(context);

    return Column(
      children: [
        _PolicyCheckboxItem(
          value: store.privacyPolicyAccepted,
          onChanged: (value) => store.setPrivacyPolicyAccepted(value ?? false),
          policyName: 'Política de Privacidade',
          policyUrl: PolicyConfig.privacyPolicyUrl,
        ),
        const SizedBox(height: 16),
        _PolicyCheckboxItem(
          value: store.sensitiveDataPolicyAccepted,
          onChanged: (value) =>
              store.setSensitiveDataPolicyAccepted(value ?? false),
          policyName: 'Política de Tratamento de Dados Sensíveis',
          policyUrl: PolicyConfig.sensitiveDataPolicyUrl,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final store = Provider.of<PolicyAcceptanceStore>(context);
    final authStore = Provider.of<AuthSessionStore>(context, listen: false);

    if (store.isSubmitting) {
      return const Center(child: Loading());
    }

    return CustomButton(
      text: 'Aceitar e Continuar',
      backgroundColor: store.canSubmit ? AppColors.green : AppColors.greyMiddle,
      textColor: store.canSubmit ? Colors.white : AppColors.grey,
      onPressed: store.canSubmit
          ? () async {
              final result = await store.submitAcceptance(
                authStore.state.session.token,
              );

              if (result != null && context.mounted) {
                // Update the session with new policy acceptance
                final updatedSession = authStore.state.session.copyWith(
                  policies: result,
                );
                authStore.updateSession(updatedSession);

                // Navigate to dashboard
                context.go('/dashboard');
              }
            }
          : null,
      typeButton: CustomButton.basic,
    );
  }
}

class _PolicyCheckboxItem extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String policyName;
  final String policyUrl;

  const _PolicyCheckboxItem({
    required this.value,
    required this.onChanged,
    required this.policyName,
    required this.policyUrl,
  });

  Future<void> _openPolicy(BuildContext context) async {
    final uri = Uri.parse(policyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível abrir o link: $policyUrl'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.purple,
          ),
          Expanded(
            child: Wrap(
              children: [
                Text(
                  'Li e concordo com a ',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => _openPolicy(context),
                  child: Text(
                    policyName,
                    style: TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 14,
                      color: AppColors.purple,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  '.',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
