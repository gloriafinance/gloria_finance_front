import 'package:church_finance_bk/auth/pages/login/store/auth_session_store.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_color.dart';
import '../theme/app_fonts.dart';
import '../widgets/app_logo_horizontal.dart';
import 'state/sidebar_state.dart';

class HeaderLayout extends StatefulWidget {
  const HeaderLayout({super.key});

  @override
  State<HeaderLayout> createState() => _HeaderLayoutState();
}

class _HeaderLayoutState extends State<HeaderLayout> {
  late BuildContext _contextRef;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contextRef = context;
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthSessionStore>(context);

    return Container(
      padding: const EdgeInsets.only(top: 4.0, bottom: 0, left: 4.0),
      height: 110,
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
          color: Colors.white,
          child: Row(
            children: [
              if (isMobile(context)) const SizedBox(width: 20),
              if (isMobile(context))
                Container(
                  margin: EdgeInsets.only(top: 42),
                  padding: const EdgeInsets.only(left: 26.0, right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      context.go('/dashboard');
                    },
                    child: Image.asset('images/applogo.jpg', height: 55),
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    context.go('/dashboard');
                  },
                  child: _logoDesktop(),
                ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Alineado al inicio
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        '${authStore.state.session.name.split(' ').first} ${authStore.state.session.name.split(' ').last}',
                        style: TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                _avatar(authStore.state.session.name),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String fullName) {
    if (fullName == '') {
      return const CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.purple,
        child: Icon(Icons.person, color: Colors.white),
      );
    }

    // Obtener las iniciales
    final List<String> nameParts = fullName.split(' ');
    String initials = '';

    if (nameParts.isNotEmpty) {
      // Primera inicial
      initials += nameParts[0][0];

      // Buscar la segunda inicial (del primer apellido o segundo nombre)
      if (nameParts.length > 1) {
        for (int i = 1; i < nameParts.length; i++) {
          if (nameParts[i].isNotEmpty) {
            initials += nameParts[i][0];
            break;
          }
        }
      }
    }

    // Si solo se encontró una inicial, usar solo esa
    initials = initials.toUpperCase();

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'trocar_senha',
              child: Row(
                children: [
                  Icon(Icons.lock_outline, color: AppColors.purple),
                  const SizedBox(width: 8),
                  Text(
                    'Trocar senha',
                    style: TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'sair',
              child: Row(
                children: [
                  Icon(Icons.logout, color: AppColors.purple),
                  const SizedBox(width: 8),
                  Text(
                    'Sair',
                    style: TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
      onSelected: (String value) {
        if (value == 'trocar_senha') {
          context.push('/change-password');
        } else if (value == 'sair') {
          final authStore = Provider.of<AuthSessionStore>(
            _contextRef,
            listen: false,
          );
          authStore.logout();
          _contextRef.go('/');
        }
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.purple,
        child: Text(
          initials.length > 2 ? initials.substring(0, 2) : initials,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.fontTitle,
          ),
        ),
      ),
    );
  }

  Widget _logoDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Provider.of<SidebarNotifier>(context, listen: false).toggle();
          },
        ),
        const SizedBox(width: 10),
        ApplicationLogoHorizontal(width: 270),
      ],
    );
  }
}
