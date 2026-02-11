import 'package:gloria_finance/core/widgets/app_logo.dart';
import 'package:flutter/material.dart';

import 'package:gloria_finance/app/store_manager.dart';

import '../../widgets/layout_auth.dart';
import 'widgets/form_email_login.dart';
import 'widgets/form_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine which form to show based on the configured experience
    final isMember = StoreManager().isMemberExperience;

    return LayoutAuth(
      height: 570,
      width: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const ApplicationLogo(height: 100),
          ),
          // Show Social Login for Member Experience, Email Login for ERP
          isMember ? const FormLogin() : const FormEmailLogin(),
        ],
      ),
    );
  }
}
