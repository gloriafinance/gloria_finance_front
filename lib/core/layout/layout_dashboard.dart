import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'header_layout.dart';
import 'menu_items.dart';
import 'sidebar_layout_dashboad.dart';

class LayoutDashboard extends ConsumerStatefulWidget {
  final Widget screen;
  final String title;

  const LayoutDashboard(this.title, {super.key, required this.screen});

  @override
  ConsumerState<LayoutDashboard> createState() => _LayoutDashboardState();
}

class _LayoutDashboardState extends ConsumerState<LayoutDashboard> {
  @override
  Widget build(BuildContext context) {
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
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
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
                      Text(
                        widget.title,
                        textAlign: TextAlign.left,
                        // Esto asegura que el texto no esté centrado
                        style: TextStyle(
                          fontFamily: AppFonts.fontMedium,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
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
