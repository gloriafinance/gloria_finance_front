import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

import 'ContributionTithesScreen.dart';

class AddContributionScreen extends StatefulWidget {
  const AddContributionScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddContributionScreen();
}

class _AddContributionScreen extends State<AddContributionScreen>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
        Text(
          'Registro de contribuições',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppFonts.fontMedium,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        screen: Container(
          margin: const EdgeInsets.only(top: 60),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: AppColors.purple,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.mustard,
                  ),
                  controller: _tabController,
                  //dividerHeight: 0,
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Tab(
                        child: Text(
                          "Dizimos",
                          style: TextStyle(
                            fontFamily: AppFonts.fontMedium,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Tab(
                        child: Text(
                          "Ofertas",
                          style: TextStyle(
                            fontFamily: AppFonts.fontMedium,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      100, // Ajusta la altura
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius: BorderRadius.circular(20),
                        // ),
                        child: ContributionTithesScreen(),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius: BorderRadius.circular(20),
                        // ),
                        child: const Text("Contenido de Ofertas"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
