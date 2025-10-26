import 'dart:convert';

import 'package:church_finance_bk/patrimony/models/patrimony_attachment_model.dart';
import 'package:church_finance_bk/patrimony/pages/assets/form/state/patrimony_asset_form_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PatrimonyAssetFormState.toFormData', () {
    test('builds multipart payload with metadata and attachments', () async {
      final state = PatrimonyAssetFormState.initial().copyWith(
        name: 'Piano Yamaha C3',
        category: 'instrument',
        value: 48000,
        valueText: 'R\$ 48.000,00',
        acquisitionDate: '15/04/2024',
        churchId: 'urn:church:central',
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
          MultipartFile.fromBytes('conteudo'.codeUnits, filename: 'inventario.pdf'),
        ],
        attachmentsToRemove: {'urn:attachment:2'},
      );

      final formData = state.toFormData();

      final fields = {for (final field in formData.fields) field.key: field.value};

      expect(fields['name'], 'Piano Yamaha C3');
      expect(fields['value'], '48000.0');
      expect(fields['churchId'], 'urn:church:central');
      expect(fields['status'], 'ACTIVE');
      expect(fields['category'], 'instrument');
      expect(fields['acquisitionDate'], '2024-04-15');
      expect(fields['notes'], 'Doado pela família');

      final attachmentsJson = fields['attachments'] as String;
      final decoded = jsonDecode(attachmentsJson) as List<dynamic>;
      expect(decoded, hasLength(1));
      expect(decoded.first['name'], 'Factura.pdf');

      final attachmentsToRemove = formData.fields
          .where((field) => field.key == 'attachmentsToRemove')
          .map((field) => field.value)
          .toList();

      expect(attachmentsToRemove, contains('urn:attachment:2'));
      expect(formData.files, hasLength(1));
      expect(formData.files.first.key, 'attachments');
      expect(formData.files.first.value.filename, 'inventario.pdf');
    });
  });
}
