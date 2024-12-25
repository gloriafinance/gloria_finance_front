import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/providers/auth_provider.dart';
import 'package:church_finance_bk/core/app_router.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/IPUBLogo.dart';
import 'package:church_finance_bk/core/widgets/background_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LayoutDashboard extends ConsumerStatefulWidget {
  final Widget screen;
  final String title;

  const LayoutDashboard(this.title, {super.key, required this.screen});

  @override
  ConsumerState<LayoutDashboard> createState() => _LayoutDashboardState();
}

class _LayoutDashboardState extends ConsumerState<LayoutDashboard> {
  AuthSessionModel session = AuthSessionModel.init();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        session = ref.watch(sessionProvider).maybeWhen(
              data: (session) => session,
              orElse: () => AuthSessionModel.init(),
            );

        if (!session.isSessionStarted()) {
          print("No hay sesión iniciada");
          ref.read(appRouterProvider).go("/");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
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
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.black),
            automaticallyImplyLeading: MediaQuery.of(context).size.width < 800,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: IPUBLogo(
                    width: 90,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
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
                          session.name,
                          style: TextStyle(
                            fontFamily: AppFonts.fontMedium,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          session.email,
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
        ),
      ),
      drawer: MediaQuery.of(context).size.width < 800
          ? const Drawer(
              child: Sidebar(),
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
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  width: 320,
                  child: const Sidebar(),
                ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
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
                        child: widget.screen,
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

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundContainer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Alineación superior izquierda
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 60),
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 120),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Church Finance',
                      style: TextStyle(
                        fontFamily: AppFonts.fontMedium,
                        fontSize: 30,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard, color: Colors.black),
                    title: const Text('Dashboard',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.black),
                    title: const Text('Profile',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.black),
                    title: const Text('Settings',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.black),
                    title: const Text('Logout',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
