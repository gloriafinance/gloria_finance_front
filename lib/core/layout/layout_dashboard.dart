import 'package:church_finance_bk/auth/stores/auth_session_store.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../menu_items.dart';
import 'header_layout.dart';
import 'sidebar_layout_dashboad.dart';

class LayoutDashboard extends StatefulWidget {
  final Widget screen;
  final Widget title;

  const LayoutDashboard(this.title, {super.key, required this.screen});

  @override
  State<LayoutDashboard> createState() => _LayoutDashboardState();
}

class _LayoutDashboardState extends State<LayoutDashboard> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AuthSessionStore>(context);

    Future.delayed(const Duration(seconds: 5)).then((_) {
      if (mounted && !store.state.isLogged()) {
        GoRouter.of(context).go('/');
      }
    });

    Toast.init(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: HeaderLayout(),
      ),
      drawer: MediaQuery.of(context).size.width < 800
          ? Drawer(
              child: Sidebar(menuItems: menuItems),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth >= 800;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Alinea el contenido superior
            children: [
              if (isLargeScreen)
                Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  width: 320,
                  child: Sidebar(menuItems: menuItems),
                ),
              Expanded(
                child: Container(
                  margin: isMobile(context)
                      ? const EdgeInsets.all(6.0)
                      : const EdgeInsets.all(10.0),
                  padding: isMobile(context)
                      ? const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 14)
                      : const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 14),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Alineación a la izquierda
                    children: [
                      widget.title,
                      Expanded(
                        child: SingleChildScrollView(
                          child: widget.screen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
