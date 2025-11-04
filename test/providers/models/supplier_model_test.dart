import 'package:church_finance_bk/providers/models/supplier_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupplierModel.fromMap', () {
    test('parses new backend keys from API payload', () {
      final model = SupplierModel.fromMap({
        'supplierId': 'urn:supplier:987654321',
        'supplierType': 'SUPPLIER',
        'supplierDNI': '987654321',
        'name': 'Proveedor Ejemplo',
        'phone': '555-1234',
      });

      expect(model.supplierId, 'urn:supplier:987654321');
      expect(model.type, 'SUPPLIER');
      expect(model.dni, '987654321');
      expect(model.name, 'Proveedor Ejemplo');
      expect(model.phone, '555-1234');
    });

    test('falls back to defaults when optional fields are missing', () {
      final model = SupplierModel.fromMap({'name': 'Fallback Supplier'});

      expect(model.type, SupplierType.SUPPLIER.apiValue);
      expect(model.dni, '');
      expect(model.phone, '');
      expect(model.name, 'Fallback Supplier');
    });
  });
}
