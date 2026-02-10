import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../store/auth_session_store.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<StatefulWidget> createState() => _FormLogin();
}

class _FormLogin extends State<FormLogin> {
  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthSessionStore>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(height: 24),
              Text(
                context.l10n.auth_login_social_title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontFamily: AppFonts.fontTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              (authStore.formState.makeRequest)
                  ? const Loading()
                  : Column(
                    children: [
                      _buttonGoogle(authStore),
                      const SizedBox(height: 16),
                      _buttonOutlook(authStore),
                    ],
                  ),
            ],
          );
        },
      ),
    );
  }

  Widget _buttonGoogle(AuthSessionStore authStore) {
    return CustomButton(
      backgroundColor: Colors.white,
      text: context.l10n.auth_login_social_google,
      textColor: AppColors.black,
      typeButton: CustomButton.basic,
      leading: SvgPicture.asset(
        'images/icons/google.svg',
        width: 24,
        height: 24,
      ),
      onPressed: () => _makeLoginGoogle(authStore),
    );
  }

  Widget _buttonOutlook(AuthSessionStore authStore) {
    return CustomButton(
      backgroundColor: const Color(0xFF0078D4),
      text: context.l10n.auth_login_social_outlook,
      textColor: Colors.white,
      typeButton: CustomButton.basic,
      leading: SvgPicture.asset(
        'images/icons/microsoft.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      onPressed: () => _makeLoginMicrosoft(authStore),
    );
  }

  void _makeLoginGoogle(AuthSessionStore authStore) async {
    if (await authStore.loginWithGoogle()) {
      if (authStore.needsPolicyAcceptance()) {
        context.go('/policy-acceptance');
      } else {
        context.go('/dashboard');
      }
    }
  }

  void _makeLoginMicrosoft(AuthSessionStore authStore) async {
    if (await authStore.loginWithMicrosoft()) {
      if (authStore.needsPolicyAcceptance()) {
        context.go('/policy-acceptance');
      } else {
        context.go('/dashboard');
      }
    }
  }
}
