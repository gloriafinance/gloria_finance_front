import 'package:church_finance_bk/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_router.dart';
import '../theme/app_color.dart';
import '../theme/app_fonts.dart';
import '../widgets/IPUBLogo.dart';

class HeaderLayout extends ConsumerStatefulWidget {
  const HeaderLayout({super.key});

  @override
  ConsumerState<HeaderLayout> createState() => _HeaderLayoutState();
}

class _HeaderLayoutState extends ConsumerState<HeaderLayout> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.watch(sessionProvider).when(
              data: (session) {
                if (!session.isSessionStarted()) {
                  ref.read(appRouterProvider).go("/");
                }
              },
              error: (error, _) => Text("Error: $error"),
              loading: () => CircularProgressIndicator(),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                IPUBLogo(
                  width: 100,
                ),
                const SizedBox(width: 20),
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
                ref.watch(sessionProvider).when(
                    data: (session) => Column(
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
                    error: (error, _) => Text("Error: $error"),
                    loading: () => CircularProgressIndicator()),
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
