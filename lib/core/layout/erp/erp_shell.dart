import 'package:church_finance_bk/core/layout/state/sidebar_state.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/auth/pages/login/store/auth_session_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import './widgets/sidebar_layout_dashboard.dart';
import 'header_layout.dart';
import 'menu_items.dart';

class ErpShell extends StatefulWidget {
  final Widget screen;

  const ErpShell({super.key, required this.screen});

  @override
  State<ErpShell> createState() => _ErpShellState();
}

class _ErpShellState extends State<ErpShell> {
  // bool _isSidebarVisible = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  // }
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final sidebarNotifier = Provider.of<SidebarNotifier>(context);
  //   sidebarNotifier.addListener(() {
  //     if (!mounted) {
  //       return; // tu widget aquí
  //     }
  //
  //     print("ppp ${sidebarNotifier.isSidebarVisible}");
  //
  //     setState(() {
  //       _isSidebarVisible = sidebarNotifier.isSidebarVisible;
  //       print(_isSidebarVisible);
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AuthSessionStore>(context);
    final storeSidebar = Provider.of<SidebarNotifier>(context);

    final List<String> roles = store.state.session.roles;
    final items = menuItems(roles);

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
      drawer:
          MediaQuery.of(context).size.width < 800 && items.isNotEmpty
              ? Drawer(child: Sidebar(menuItems: items))
              : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile(context) && items.isNotEmpty)
                _sidebar(storeSidebar, roles),
              Expanded(
                child: Container(
                  margin:
                      isMobile(context)
                          ? const EdgeInsets.all(6.0)
                          : const EdgeInsets.all(10.0),
                  padding:
                      isMobile(context)
                          ? const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 14,
                          )
                          : const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 14,
                          ),
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
                    children: [
                      //widget.title,
                      Expanded(
                        child: SingleChildScrollView(child: widget.screen),
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

  Widget _sidebar(SidebarNotifier storeSidebar, List<String> roles) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: storeSidebar.isSidebarVisible ? 330 : 20,
      child: Column(
        children: [
          if (storeSidebar.isSidebarVisible)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Sidebar(menuItems: menuItems(roles)),
              ),
            ),
        ],
      ),
    );
  }
}
