import 'package:church_finance_bk/core/layout/state/sidebar_state.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../sidebar_background.dart';

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;

  const Sidebar({super.key, required this.menuItems});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_version.isEmpty) {
      _version = context.l10n.auth_layout_version_loading;
    }
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
      builder:
          (context, menuState, _) {
            final location = GoRouterState.of(context).uri.toString();
            _syncExpandedIndex(menuState, location);

            return Stack(
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
                          final IconData? sectionIcon =
                              section['icon'] as IconData?;
                          final bool hasSectionIcon = sectionIcon != null;
                          final String sectionLabel = context.l10n.menuLabel(
                            section['key'] as String,
                          );
                          return Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              initiallyExpanded: menuState.expandedIndex == index,
                              maintainState: true,
                              onExpansionChanged: (expanded) {
                                menuState.setExpanded(index);
                              },
                              tilePadding:
                                  hasSectionIcon
                                      ? null
                                      : const EdgeInsets.only(
                                        left: 8,
                                        right: 16,
                                      ),
                              title: Row(
                                children: [
                                  if (hasSectionIcon) ...[
                                    Icon(sectionIcon, color: Colors.white),
                                    const SizedBox(width: 10.0),
                                  ],
                                  Expanded(
                                    child: Text(
                                      hasSectionIcon
                                          ? sectionLabel
                                          : sectionLabel.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: AppFonts.fontSubTitle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              children:
                                  (section['items'] as List).map<Widget>((item) {
                                    final IconData? itemIcon =
                                        item['icon'] as IconData?;
                                    final bool hasItemIcon = itemIcon != null;
                                    final String itemLabel = context.l10n
                                        .menuLabel(item['key'] as String);

                                    return ListTile(
                                      contentPadding:
                                          hasItemIcon
                                              ? null
                                              : const EdgeInsets.only(
                                                left: 8,
                                                right: 16,
                                              ),
                                      leading:
                                          hasItemIcon
                                              ? Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 20,
                                                ),
                                                child: Icon(
                                                  itemIcon,
                                                  color: Colors.white,
                                                ),
                                              )
                                              : null,
                                      title: Text(
                                        hasItemIcon
                                            ? itemLabel
                                            : itemLabel.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontFamily: AppFonts.fontText,
                                        ),
                                      ),
                                      onTap: () {
                                        if (isMobile(context)) {
                                          Navigator.of(context).pop();
                                        }
                                        context.go(item['to']);
                                      },
                                    );
                                  }).toList(),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          context.l10n.auth_layout_footer(DateTime.now().year),
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
                ),
              ],
            );
          },
    );
  }

  void _syncExpandedIndex(SidebarNotifier menuState, String location) {
    final targetIndex = _resolveExpandedIndex(location);
    if (targetIndex != -1 && targetIndex != menuState.expandedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        menuState.setExpandedIndex(targetIndex);
      });
      return;
    }

    if (targetIndex == -1 &&
        menuState.expandedIndex == -1 &&
        widget.menuItems.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        menuState.setExpandedIndex(0);
      });
    }
  }

  int _resolveExpandedIndex(String location) {
    for (var index = 0; index < widget.menuItems.length; index++) {
      final section = widget.menuItems[index];
      final items = section['items'] as List<dynamic>;
      for (final item in items) {
        final to = item['to'] as String?;
        if (to == null) {
          continue;
        }
        if (location.startsWith(to)) {
          return index;
        }
      }
    }
    return -1;
  }
}
