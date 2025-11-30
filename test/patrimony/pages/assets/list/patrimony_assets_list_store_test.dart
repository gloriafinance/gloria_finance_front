import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_asset_model.dart';
import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_inventory_import_result.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/list/store/patrimony_assets_list_store.dart';
import 'package:church_finance_bk/features/erp/patrimony/services/patrimony_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubPatrimonyService extends PatrimonyService {
  final PatrimonyInventoryImportResult importResult;
  final PaginateResponse<PatrimonyAssetModel> fetchResponse;
  bool throwOnImport;
  bool importCalled = false;
  bool fetchCalled = false;

  _StubPatrimonyService({
    required this.importResult,
    PaginateResponse<PatrimonyAssetModel>? fetchResponse,
    this.throwOnImport = false,
  }) : fetchResponse = fetchResponse ?? PaginateResponse.init();

  @override
  Future<PatrimonyInventoryImportResult> importInventoryChecklist({
    required MultipartFile file,
  }) async {
    importCalled = true;
    if (throwOnImport) {
      throw Exception('import error');
    }
    return importResult;
  }

  @override
  Future<PaginateResponse<PatrimonyAssetModel>> fetchAssets({
    int page = 1,
    int perPage = 10,
    String? search,
    String? status,
    String? category,
  }) async {
    fetchCalled = true;
    return fetchResponse;
  }
}

void main() {
  group('PatrimonyAssetsListStore.importInventoryChecklist', () {
    test('returns result and refreshes list on success', () async {
      final service = _StubPatrimonyService(
        importResult: const PatrimonyInventoryImportResult(
          processed: 10,
          updated: 8,
          skipped: 2,
          errors: 0,
        ),
      );

      final store = PatrimonyAssetsListStore(service: service);
      final file = MultipartFile.fromString(
        'conteudo',
        filename: 'checklist.csv',
      );

      final result = await store.importInventoryChecklist(file);

      expect(service.importCalled, isTrue);
      expect(service.fetchCalled, isTrue);
      expect(result, isNotNull);
      expect(result!.processed, 10);
      expect(store.importingInventory, isFalse);
    });

    test('returns null and keeps list untouched on failure', () async {
      final service = _StubPatrimonyService(
        importResult: const PatrimonyInventoryImportResult(
          processed: 0,
          updated: 0,
          skipped: 0,
          errors: 0,
        ),
        throwOnImport: true,
      );

      final store = PatrimonyAssetsListStore(service: service);
      final file = MultipartFile.fromString(
        'conteudo',
        filename: 'checklist.csv',
      );

      final result = await store.importInventoryChecklist(file);

      expect(service.importCalled, isTrue);
      expect(service.fetchCalled, isFalse);
      expect(result, isNull);
      expect(store.importingInventory, isFalse);
    });
  });
}
