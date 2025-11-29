import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_asset_model.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/assets/form/patrimony_asset_form_screen.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/assets/list/patrimony_assets_list_screen.dart';
import 'package:go_router/go_router.dart';

List<RouteBase> patrimonyRouter() {
  return [
    GoRoute(
      path: '/patrimony/assets',
      pageBuilder:
          (context, state) =>
              transitionCustom(const PatrimonyAssetsListScreen()),
    ),
    GoRoute(
      path: '/patrimony/assets/new',
      pageBuilder:
          (context, state) =>
              transitionCustom(const PatrimonyAssetFormScreen()),
    ),
    GoRoute(
      path: '/patrimony/assets/:assetId/edit',
      pageBuilder: (context, state) {
        final assetId = state.pathParameters['assetId']!;
        final asset =
            state.extra is PatrimonyAssetModel
                ? state.extra as PatrimonyAssetModel
                : null;
        return transitionCustom(
          PatrimonyAssetFormScreen(assetId: assetId, asset: asset),
        );
      },
    ),
  ];
}
