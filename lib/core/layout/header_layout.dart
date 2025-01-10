import 'package:church_finance_bk/auth/stores/auth_session_store.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_color.dart';
import '../theme/app_fonts.dart';
import '../widgets/IPUBLogo.dart';

class HeaderLayout extends StatefulWidget {
  const HeaderLayout({super.key});

  @override
  State<HeaderLayout> createState() => _HeaderLayoutState();
}

class _HeaderLayoutState extends State<HeaderLayout> {
  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthSessionStore>(context);

    return Container(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: MediaQuery.of(context).size.width < 800,
        flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                if (isMobile(context)) const SizedBox(width: 40),
                IPUBLogo(),
                const SizedBox(width: 20),
                if (!isMobile(context))
                  Text(
                    'Church Finance',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: AppFonts.fontMedium,
                      color: AppColors.purple,
                    ),
                  ),
              ],
            )),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Alineado al inicio
                  children: [
                    Text(
                      authStore.state.session.name,
                      style: TextStyle(
                        fontFamily: AppFonts.fontMedium,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      authStore.state.session.email,
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: AppFonts.fontLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.purple,
                  child: const Text(
                    'AB',
                    style: TextStyle(color: Colors.white),
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
