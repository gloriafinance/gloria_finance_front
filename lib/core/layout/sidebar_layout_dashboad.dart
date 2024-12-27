import 'package:church_finance_bk/core/app_router.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sidebar_backgroud.dart';

class Sidebar extends ConsumerWidget {
  final List<Map<String, dynamic>> menuItems;

  const Sidebar({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        const SidebarBackground(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final section = menuItems[index];
                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // Eliminar líneas
                    ),
                    child: ExpansionTile(
                      title: Row(
                        children: [
                          Icon(section['icon'], color: Colors.white),
                          const SizedBox(width: 10.0),
                          Text(
                            section['label'],
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.fontLight),
                          ),
                        ],
                      ),
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      children: (section['items'] as List)
                          .map<Widget>((item) => ListTile(
                                leading: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(item['icon'],
                                        color: Colors.white)),
                                title: Text(
                                  item['label'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.fontLight),
                                ),
                                onTap: () {
                                  ref.read(appRouterProvider).go(item['to']);
                                },
                              ))
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
