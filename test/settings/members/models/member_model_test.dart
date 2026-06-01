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
        'status': 'APPROVED',
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
          'status': 'APPROVED',
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

    test('parses APPROVED status', () {
      final member = MemberModel.fromJson({
        'memberId': 'm-003',
        'name': 'João',
        'email': 'joao@example.com',
        'phone': '5511999999999',
        'dni': '00000000000',
        'conversionDate': '2021-01-01',
        'birthdate': '2000-01-01',
        'isMinister': false,
        'isTreasurer': false,
        'status': 'APPROVED',
        'address': '',
      });

      expect(member.status.value, 'APPROVED');
    });

    test('throws on invalid status', () {
      expect(
        () => MemberModel.fromJson({
          'memberId': 'm-004',
          'name': 'Invalid',
          'email': 'invalid@example.com',
          'phone': '5511999999999',
          'dni': '00000000000',
          'conversionDate': '2021-01-01',
          'birthdate': '2000-01-01',
          'isMinister': false,
          'isTreasurer': false,
          'status': 'UNKNOWN',
          'address': '',
        }),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on missing status', () {
      expect(
        () => MemberModel.fromJson({
          'memberId': 'm-005',
          'name': 'Missing',
          'email': 'missing@example.com',
          'phone': '5511999999999',
          'dni': '00000000000',
          'conversionDate': '2021-01-01',
          'birthdate': '2000-01-01',
          'isMinister': false,
          'isTreasurer': false,
          'address': '',
        }),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
