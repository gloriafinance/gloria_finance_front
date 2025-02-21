import 'package:church_finance_bk/core/layout/state/sidebar_state.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../sidebar_backgroud.dart';

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;

  const Sidebar({
    super.key,
    required this.menuItems,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String _version = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SidebarNotifier>(
        builder: (context, menuState, _) => Stack(
              children: [
                const SidebarBackground(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.menuItems.length,
                        itemBuilder: (context, index) {
                          final section = widget.menuItems[index];
                          return Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              initiallyExpanded:
                                  menuState.expandedIndex == index,
                              maintainState: true,
                              onExpansionChanged: (expanded) {
                                menuState.setExpanded(index);
                              },
                              title: Row(
                                children: [
                                  Icon(section['icon'], color: Colors.white),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      section['label'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: AppFonts.fontSubTitle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              children: (section['items'] as List)
                                  .map<Widget>((item) => ListTile(
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Icon(item['icon'],
                                              color: Colors.white),
                                        ),
                                        title: Text(
                                          item['label'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: AppFonts.fontText,
                                          ),
                                        ),
                                        onTap: () {
                                          context.go(item['to']);
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '© ${DateTime.now().year} Jaspesoft CNPJ 43.716.343/0001-60 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.fontSubTitle,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          _version,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.fontSubTitle,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ));
  }
}
