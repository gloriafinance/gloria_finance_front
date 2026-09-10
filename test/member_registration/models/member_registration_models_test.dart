import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/member_registration/models/member_registration_models.dart';

void main() {
  group('PublicChurchInfo', () {
    test('reads the church country from the public registration contract', () {
      final church = PublicChurchInfo.fromJson({
        'churchId': 'church-1',
        'churchName': 'Iglesia Central',
        'country': 'VE',
      });

      expect(church.country, 'VE');
    });
  });
}
