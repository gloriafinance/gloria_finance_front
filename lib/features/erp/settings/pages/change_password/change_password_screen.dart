import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/change_password_store.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordStore(),
      child: const _ChangePasswordContent(),
    );
  }
}

class _ChangePasswordContent extends StatelessWidget {
  const _ChangePasswordContent();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChangePasswordStore>();
    final state = store.state;
    final l10n = context.l10n;

    if (state.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Toast.showMessage(
          l10n.member_change_password_success_message,
          ToastType.info,
        );
        context.pop();
      });
    }

    Widget _header(BuildContext context) {
      return Row(
        children: [
          GestureDetector(
            onTap: () => context.go("/dashboard"),
            child: Icon(Icons.arrow_back_ios, color: AppColors.purple),
          ),
          Text(
            l10n.member_change_password_header_title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(context),
        Center(
          child: Container(
            width: 650,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //_buildHeader(context, l10n),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordField(
                        label: l10n.member_change_password_current_label,
                        value: state.currentPassword,
                        onChanged: store.setCurrentPassword,
                        isVisible: state.isCurrentPasswordVisible,
                        onToggleVisibility:
                            store.toggleCurrentPasswordVisibility,
                        errorText:
                            state.errorMessage ==
                                    'member_change_password_error_current'
                                ? l10n.member_change_password_error_current
                                : null,
                      ),
                      const SizedBox(height: 24),
                      _buildPasswordField(
                        label: l10n.member_change_password_new_label,
                        value: state.newPassword,
                        onChanged: store.setNewPassword,
                        isVisible: state.isNewPasswordVisible,
                        onToggleVisibility: store.toggleNewPasswordVisibility,
                      ),
                      const SizedBox(height: 12),
                      _buildValidationRule(
                        l10n.member_change_password_rule_length,
                        store.hasMinLength,
                      ),
                      _buildValidationRule(
                        l10n.member_change_password_rule_uppercase,
                        store.hasUppercase,
                      ),
                      _buildValidationRule(
                        l10n.member_change_password_rule_number,
                        store.hasNumber,
                      ),
                      const SizedBox(height: 24),
                      _buildPasswordField(
                        label: l10n.member_change_password_confirm_label,
                        value: state.confirmPassword,
                        onChanged: store.setConfirmPassword,
                        isVisible: state.isConfirmPasswordVisible,
                        onToggleVisibility:
                            store.toggleConfirmPasswordVisibility,
                        errorText:
                            !store.passwordsMatch &&
                                    state.confirmPassword.isNotEmpty
                                ? l10n.member_change_password_error_match
                                : null,
                      ),
                      const SizedBox(height: 32),
                      if (state.isLoading)
                        const Center(child: Loading())
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: l10n.member_change_password_btn_save,
                                onPressed:
                                    store.isValid
                                        ? () => store.changePassword()
                                        : null,
                                backgroundColor: AppColors.purple,
                                textColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                text: l10n.member_change_password_btn_cancel,
                                onPressed: () => context.pop(),
                                backgroundColor: AppColors.purple,
                                textColor: AppColors.purple,
                                typeButton: CustomButton.outline,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, dynamic l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.member_change_password_header_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.member_change_password_header_subtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          obscureText: !isVisible,
          decoration: InputDecoration(
            isDense: true,
            hintText: '••••••••',
            errorText: errorText,
            suffixIcon: IconButton(
              icon: Icon(
                isVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.purple, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationRule(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: isValid ? Colors.green : Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13,
              color: isValid ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
