import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/member_experience/profile/models/member_profile_model.dart';
import 'package:gloria_finance/features/erp/settings/members/models/member_status.dart';

void main() {
  group('MemberProfileModel', () {
    test('parses key and url separately', () {
      final model = MemberProfileModel.fromJson({
        'memberId': 'member-1',
        'name': 'Ana',
        'email': 'ana@example.com',
        'phone': '5511999999999',
        'dni': '123',
        'profilePhoto': '2026/6/photo.jpg',
        'profilePhotoUrl': 'https://cdn.example.com/photo.jpg',
        'createdAt': '2024-01-01',
        'conversionDate': '2024-01-02',
        'baptismDate': '2024-01-03',
        'birthdate': '1990-01-01',
        'status': 'APPROVED',
        'church': {'churchId': 'church-1', 'name': 'Church'},
      });

      expect(model.profilePhoto, '2026/6/photo.jpg');
      expect(model.profilePhotoUrl, 'https://cdn.example.com/photo.jpg');
      expect(model.status, MemberStatus.approved);
    });
  });
}
