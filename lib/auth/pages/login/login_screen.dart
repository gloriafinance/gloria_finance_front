import 'package:church_finance_bk/auth/widgets/layout_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/form_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutAuth(
      height: 570,
      width: 500,
      child: FormLogin(),
    );
  }
}
