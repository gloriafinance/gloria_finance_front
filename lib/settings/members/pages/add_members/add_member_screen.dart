import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/settings/members/models/member_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/form_member_store.dart';
import 'widgets/form_member.dart';

class AddMemberScreen extends StatelessWidget {
  final MemberModel? member;

  const AddMemberScreen({super.key, this.member});

  bool get isEditing => member != null;

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => FormMemberStore(member: member),
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
                isEditing ? "Editar membro" : "Registrar membro",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          screen: FormMember(isEditing: isEditing)),
    );
  }
}
