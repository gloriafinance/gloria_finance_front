import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_asset_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PatrimonyAssetModel.fromMap', () {
    test('parses attachments and history correctly', () {
      final model = PatrimonyAssetModel.fromMap({
        'assetId': 'asset-123',
        'code': 'BEM-000123',
        'name': 'Piano Yamaha C3',
        'category': 'instrument',
        'acquisitionDate': '2024-04-15T00:00:00.000Z',
        'value': 48000,
        'churchId': 'urn:church:central',
        'location': 'Salão principal',
        'responsibleId': 'urn:user:music-director',
        'status': 'ACTIVE',
        'notes': 'Donado pela família Silva',
        'documentsPending': false,
        'attachments': [
          {
            'attachmentId': 'urn:attachment:1',
            'name': 'Factura.pdf',
            'url': 'https://storage.example.com/assets/piano/factura.pdf',
            'mimetype': 'application/pdf',
            'size': 524288,
            'uploadedAt': '2024-04-16T02:31:00.000Z',
          },
        ],
        'history': [
          {
            'action': 'CREATED',
            'performedBy': 'urn:user:admin',
            'performedAt': '2024-04-16T02:31:00.000Z',
            'notes': 'Registro inicial',
            'changes': {
              'name': {'current': 'Piano Yamaha C3'},
              'location': {'current': 'Salão principal'},
            },
          },
        ],
        'createdAt': '2024-04-16T02:31:00.000Z',
        'updatedAt': '2024-04-16T02:31:00.000Z',
      });

      expect(model.assetId, 'asset-123');
      expect(model.categoryLabel, 'Instrumentos');
      expect(model.valueLabel, 'R\$ 48.000,00');
      expect(model.acquisitionDateLabel, '15/04/2024');
      expect(model.attachments, hasLength(1));
      expect(model.attachments.first.name, 'Factura.pdf');
      expect(model.attachments.first.formattedSize, '512.0 KB');
      expect(model.history, hasLength(1));
      expect(model.history.first.action, 'CREATED');
      expect(
        model.history.first.formattedChanges,
        contains('location: Salão principal'),
      );
      expect(model.documentsPending, isFalse);
      expect(model.statusLabel, 'Ativo');
    });
  });
}
