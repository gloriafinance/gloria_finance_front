import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/app_logo.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/policy_config.dart';
import '../../widgets/layout_auth.dart';
import '../login/store/auth_session_store.dart';
import 'store/policy_acceptance_store.dart';

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
              const Center(child: ApplicationLogo(height: 80)),
              const SizedBox(height: 24),
              _buildTitle(context),
              const SizedBox(height: 16),
              _buildDescription(context),
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

  Widget _buildTitle(BuildContext context) {
    final l10n = context.l10n;
    return Text(
      l10n.auth_policies_title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: AppColors.purple,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final l10n = context.l10n;
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
            l10n.auth_policies_info_title,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.auth_policies_info_body,
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
          policyName: context.l10n.auth_policies_privacy,
          policyUrl: PolicyConfig.privacyPolicyUrl,
        ),
        const SizedBox(height: 16),
        _PolicyCheckboxItem(
          value: store.sensitiveDataPolicyAccepted,
          onChanged:
              (value) => store.setSensitiveDataPolicyAccepted(value ?? false),
          policyName: context.l10n.auth_policies_sensitive,
          policyUrl: PolicyConfig.sensitiveDataPolicyUrl,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final store = Provider.of<PolicyAcceptanceStore>(context);
    final authStore = Provider.of<AuthSessionStore>(context, listen: false);
    final l10n = context.l10n;

    if (store.isSubmitting) {
      return const Center(child: Loading());
    }

    String? errorText;
    if (store.errorMessage == 'auth_policies_submit_error_null') {
      errorText = l10n.auth_policies_submit_error_null;
    } else if (store.errorMessage == 'auth_policies_submit_error_generic') {
      errorText = l10n.auth_policies_submit_error_generic;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorText != null) ...[
          Text(
            errorText,
            style: TextStyle(
              color: Colors.red,
              fontFamily: AppFonts.fontSubTitle,
            ),
          ),
          const SizedBox(height: 12),
        ],
        CustomButton(
          text: l10n.auth_policies_accept_and_continue,
          backgroundColor:
              store.canSubmit ? AppColors.green : AppColors.greyMiddle,
          textColor: store.canSubmit ? Colors.white : AppColors.grey,
          onPressed:
              store.canSubmit
                  ? () async {
                    final result = await store.submitAcceptance(
                      authStore.state.session.token,
                    );

                    if (result != null && context.mounted) {
                      final updatedSession = authStore.state.session.copyWith(
                        policies: result,
                      );
                      authStore.updateSession(updatedSession);
                      context.go('/dashboard');
                    }
                  }
                  : null,
          typeButton: CustomButton.basic,
        ),
      ],
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
    final l10n = context.l10n;
    final uri = Uri.parse(policyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.auth_policies_link_error(policyUrl),
            ),
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
                  context.l10n.auth_policies_checkbox_prefix,
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
