import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_asset_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/patrimony_asset_form_store.dart';
import 'widgets/patrimony_asset_form.dart';

class PatrimonyAssetFormScreen extends StatelessWidget {
  final String? assetId;
  final PatrimonyAssetModel? asset;

  const PatrimonyAssetFormScreen({super.key, this.assetId, this.asset});

  bool get isEditing => assetId != null;

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => PatrimonyAssetFormStore(assetId: assetId, asset: asset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), const PatrimonyAssetForm()],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final title = Text(
      isEditing ? 'Editar bem patrimonial' : 'Registrar bem patrimonial',
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
          Row(children: [backButton, const SizedBox(width: 8), title]),
          const SizedBox(height: 12),
        ],
      );
    }

    return Row(children: [backButton, const SizedBox(width: 12), title]);
  }
}
