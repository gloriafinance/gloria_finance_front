import 'package:gloria_finance/features/erp/settings/members/models/member_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MemberModel', () {
    test('uses direct address field when provided', () {
      final member = MemberModel.fromJson({
        'memberId': 'm-001',
        'name': 'Ana Souza',
        'email': 'ana@example.com',
        'phone': '5511988887777',
        'dni': '12345678900',
        'conversionDate': '2020-01-01',
        'birthdate': '1990-05-10',
        'isMinister': false,
        'isTreasurer': false,
        'active': true,
        'address': 'Rua das Flores, 100',
      });

      expect(member.address, 'Rua das Flores, 100');
    });

    test(
      'builds address from segmented fields when direct value is absent',
      () {
        final member = MemberModel.fromJson({
          'memberId': 'm-002',
          'name': 'Carlos Lima',
          'email': 'carlos@example.com',
          'phone': '5511977776666',
          'dni': '98765432100',
          'conversionDate': '2019-03-15',
          'birthdate': '1985-07-22',
          'isMinister': true,
          'isTreasurer': false,
          'active': true,
          'addressStreet': 'Avenida Central',
          'addressNumber': '250',
          'addressComplement': 'Bloco B',
          'addressDistrict': 'Centro',
          'addressCity': 'Sao Paulo',
          'addressState': 'SP',
          'addressZipCode': '01234-567',
        });

        expect(
          member.address,
          'Avenida Central, 250, Bloco B, Centro, Sao Paulo/SP, 01234-567',
        );
      },
    );
  });
}
