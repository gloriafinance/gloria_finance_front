import 'package:church_finance_bk/auth/widgets/layout_auth.dart';
import 'package:church_finance_bk/core/widgets/app_logo.dart';
import 'package:flutter/material.dart';

import 'widgets/form_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutAuth(
      height: 570,
      width: 500,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: const ApplicationLogo(height: 100),
          ),
          FormLogin()
        ],
      ),
    );
  }
}
