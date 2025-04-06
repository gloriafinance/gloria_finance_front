import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/form_member_store.dart';
import 'widgets/form_member.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => FormMemberStore(),
      child: LayoutDashboard(
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go("/members"),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.purple,
                ),
              ),
              Text(
                "Registrar membro",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          screen: FormMember()),
    );
  }
}
