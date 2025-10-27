import 'dart:convert';

import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_enums.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_model.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_attachment_model.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_history_entry.dart';
import 'package:church_finance_bk/patrimony/pages/assets/form/state/patrimony_asset_form_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PatrimonyAssetFormState.toFormData', () {
    test('builds multipart payload with metadata and attachments', () async {
      final state = PatrimonyAssetFormState.initial().copyWith(
        code: 'BEM-000123',
        name: 'Piano Yamaha C3',
        category: 'instrument',
        value: 48000,
        valueText: 'R\$ 48.000,00',
        quantity: 3,
        quantityText: '3',
        acquisitionDate: '15/04/2024',
        location: 'Salão principal',
        responsibleId: 'urn:user:music-director',
        status: 'ACTIVE',
        notes: 'Doado pela família',
        existingAttachments: [
          PatrimonyAttachmentModel(
            attachmentId: 'urn:attachment:1',
            name: 'Factura.pdf',
            url: 'https://storage.example.com/assets/piano/factura.pdf',
            mimetype: 'application/pdf',
            size: 524288,
            uploadedAt: DateTime.parse('2024-04-16T02:31:00.000Z'),
          ),
        ],
        newAttachments: [
          PatrimonyNewAttachment(
            file: MultipartFile.fromBytes(
              'conteudo'.codeUnits,
              filename: 'inventario.pdf',
            ),
            name: 'inventario.pdf',
            size: 'conteudo'.codeUnits.length,
            mimeType: 'application/pdf',
          ),
        ],
        attachmentsToRemove: {'urn:attachment:2'},
      );

      final formData = state.toFormData();

      final fields = {
        for (final field in formData.fields) field.key: field.value,
      };

      expect(fields['name'], 'Piano Yamaha C3');
      expect(fields['value'], '48000.0');
      expect(fields['code'], 'BEM-000123');
      expect(fields['quantity'], '3');
      expect(fields['status'], 'ACTIVE');
      expect(fields['category'], 'instrument');
      expect(fields['acquisitionDate'], '2024-04-15');
      expect(fields['notes'], 'Doado pela família');

      final attachmentsJson = fields['attachments'] as String;
      final decoded = jsonDecode(attachmentsJson) as List<dynamic>;
      expect(decoded, hasLength(1));
      expect(decoded.first['name'], 'Factura.pdf');

      final attachmentsToRemoveJson = fields['attachmentsToRemove'];
      expect(attachmentsToRemoveJson, isNotNull);

      final attachmentsToRemove =
          (jsonDecode(attachmentsToRemoveJson!) as List<dynamic>)
              .cast<String>();

      expect(attachmentsToRemove, contains('urn:attachment:2'));
      expect(formData.files, hasLength(1));
      expect(formData.files.first.key, 'attachments');
      expect(formData.files.first.value.filename, 'inventario.pdf');
    });

    test('omits immutable fields when requested', () {
      final state = PatrimonyAssetFormState.initial().copyWith(
        code: 'BEM-000999',
        name: 'Projeto Som',
        category: 'equipment',
        value: 2500,
        valueText: 'R\$ 2.500,00',
        quantity: 4,
        quantityText: '4',
        acquisitionDate: '10/06/2024',
        location: 'Sala de áudio',
      );

      final formData = state.toFormData(includeImmutableFields: false);

      final keys = formData.fields.map((entry) => entry.key).toSet();

      expect(keys, isNot(contains('code')));
      expect(keys, isNot(contains('quantity')));
    });
  });

  group('PatrimonyAssetFormState.fromModel', () {
    test('hydrates state with model data for editing', () {
      final attachment = PatrimonyAttachmentModel(
        attachmentId: 'urn:attachment:1',
        name: 'Factura.pdf',
        url: 'https://storage.example.com/assets/piano/factura.pdf',
        mimetype: 'application/pdf',
        size: 524288,
        uploadedAt: DateTime.parse('2024-04-16T02:31:00.000Z'),
      );

      final asset = PatrimonyAssetModel(
        assetId: 'asset-123',
        code: 'BEM-000123',
        name: 'Piano Yamaha C3',
        category: PatrimonyAssetCategory.instrument,
        acquisitionDate: DateTime.parse('2024-04-15T00:00:00.000Z'),
        value: 48000,
        quantity: 2,
        churchId: 'urn:church:central',
        location: 'Salão principal',
        responsibleId: 'urn:user:music-director',
        status: PatrimonyAssetStatus.active,
        attachments: [attachment],
        history: const <PatrimonyHistoryEntry>[],
        documentsPending: false,
        notes: 'Doado pela família',
        createdAt: DateTime.parse('2024-04-16T02:31:00.000Z'),
        updatedAt: DateTime.parse('2024-04-16T02:31:00.000Z'),
      );

      final state = PatrimonyAssetFormState.fromModel(asset);

      expect(state.isEditing, isTrue);
      expect(state.assetId, 'asset-123');
      expect(state.name, 'Piano Yamaha C3');
      expect(state.category, PatrimonyAssetCategory.instrument.apiValue);
      expect(state.code, 'BEM-000123');
      expect(state.quantity, 2);
      expect(state.quantityText, '2');
      expect(state.status, PatrimonyAssetStatus.active.apiValue);
      expect(state.value, 48000);
      expect(state.valueText, CurrencyFormatter.formatCurrency(48000));
      expect(state.acquisitionDate, '15/04/2024');
      expect(state.location, 'Salão principal');
      expect(state.responsibleId, 'urn:user:music-director');
      expect(state.notes, 'Doado pela família');
      expect(state.existingAttachments, hasLength(1));
      expect(state.newAttachments, isEmpty);
      expect(state.attachmentsToRemove, isEmpty);
    });
  });
}
