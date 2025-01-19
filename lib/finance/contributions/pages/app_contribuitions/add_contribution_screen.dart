import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'contribution_offerings_screen.dart';
import 'contribution_tithes_screen.dart';
import 'store/form_record_offerings_store.dart';
import 'store/form_tithes_store.dart';

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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FormTitheStore()),
          ChangeNotifierProvider(create: (_) => FormRecordOfferingStore())
        ],
        child: LayoutDashboard(
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.go("/contributions_list"),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.purple,
                  ),
                ),
                Text(
                  'Registro de contribuições',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: AppFonts.fontMedium,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
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
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Tab(
                            child: Text(
                              "Dízimos",
                              style: TextStyle(
                                fontFamily: AppFonts.fontMedium,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
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
                      height: MediaQuery.of(context).size.height - 100,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            child: ContributionTithesScreen(),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            child: ContributionOfferingsScreen(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
