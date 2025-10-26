import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/patrimony/pages/assets/detail/store/patrimony_asset_detail_store.dart';
import 'package:church_finance_bk/patrimony/pages/assets/detail/widgets/patrimony_asset_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PatrimonyAssetDetailScreen extends StatelessWidget {
  final String assetId;

  const PatrimonyAssetDetailScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => PatrimonyAssetDetailStore()..loadAsset(assetId),
      child: LayoutDashboard(
        Builder(builder: (context) => _header(context)),
        screen: PatrimonyAssetDetailView(assetId: assetId),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final title = Text(
      'Detalhes do bem',
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );

    final backButton = GestureDetector(
      onTap: () => context.go('/patrimony/assets'),
      child: const Icon(Icons.arrow_back_ios, color: AppColors.purple),
    );

    if (isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              backButton,
              const SizedBox(width: 8),
              title,
            ],
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    return Row(
      children: [
        backButton,
        const SizedBox(width: 12),
        title,
      ],
    );
  }
}
