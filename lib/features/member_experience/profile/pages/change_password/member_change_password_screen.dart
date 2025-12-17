import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/member_change_password_store.dart';

class MemberChangePasswordScreen extends StatelessWidget {
  const MemberChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemberChangePasswordStore(),
      child: const _MemberChangePasswordContent(),
    );
  }
}

class _MemberChangePasswordContent extends StatelessWidget {
  const _MemberChangePasswordContent();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MemberChangePasswordStore>();
    final state = store.state;
    final l10n = context.l10n;

    // Listen for success state to navigate back
    if (state.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Toast.showMessage(
          l10n.member_change_password_success_message,
          ToastType.info,
        );
        context.pop();
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context, l10n),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Current Password
                    _buildPasswordField(
                      label: l10n.member_change_password_current_label,
                      value: state.currentPassword,
                      onChanged: store.setCurrentPassword,
                      isVisible: state.isCurrentPasswordVisible,
                      onToggleVisibility: store.toggleCurrentPasswordVisibility,
                      errorText:
                          state.errorMessage ==
                                  'member_change_password_error_current'
                              ? l10n.member_change_password_error_current
                              : null,
                    ),
                    const SizedBox(height: 16),

                    // New Password
                    _buildPasswordField(
                      label: l10n.member_change_password_new_label,
                      value: state.newPassword,
                      onChanged: store.setNewPassword,
                      isVisible: state.isNewPasswordVisible,
                      onToggleVisibility: store.toggleNewPasswordVisibility,
                    ),
                    const SizedBox(height: 8),
                    // Validations
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
                    const SizedBox(height: 16),

                    // Confirm Password
                    _buildPasswordField(
                      label: l10n.member_change_password_confirm_label,
                      value: state.confirmPassword,
                      onChanged: store.setConfirmPassword,
                      isVisible: state.isConfirmPasswordVisible,
                      onToggleVisibility: store.toggleConfirmPasswordVisibility,
                      errorText:
                          !store.passwordsMatch &&
                                  state.confirmPassword.isNotEmpty
                              ? l10n.member_change_password_error_match
                              : null,
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    if (state.isLoading)
                      const Center(child: Loading())
                    else ...[
                      SizedBox(
                        width: double.infinity,
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
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: l10n.member_change_password_btn_cancel,
                          onPressed: () => context.pop(),
                          backgroundColor: AppColors.purple,
                          textColor: AppColors.purple,
                          typeButton: CustomButton.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 24, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.member_change_password_header_title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.member_change_password_header_subtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
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
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
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
              borderSide: const BorderSide(color: AppColors.purple),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationRule(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            Icons.check,
            size: 16,
            color: isValid ? Colors.green : Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 12,
              color: isValid ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
