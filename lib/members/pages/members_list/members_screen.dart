import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(_header(context),
        screen: Column(
          children: [],
        ));
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Listado de membros",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontMedium,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _buttons(context),
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      children: [
        ButtonActionTable(
            color: AppColors.purple,
            text: "Registrar novo membro",
            onPressed: () => GoRouter.of(context).go('/member/add'),
            icon: Icons.add_reaction_outlined),
      ],
    );
  }
}
