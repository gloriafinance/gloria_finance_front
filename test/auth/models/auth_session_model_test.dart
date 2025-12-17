import 'package:church_finance_bk/features/auth/auth_session_model.dart';
import 'package:church_finance_bk/features/auth/models/policy_acceptance_model.dart';
import 'package:church_finance_bk/features/auth/models/policy_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthSessionModel', () {
    test('creates empty model', () {
      final model = AuthSessionModel.empty();

      expect(model.token, '');
      expect(model.name, '');
      expect(model.policies.privacyPolicy.accepted, false);
      expect(model.churchName, '');
      expect(model.isSuperUser, false);
    });

    test('parses from JSON with new structure (nested church, new fields)', () {
      final json = {
        "name": "Angel Vicente Bejarano Afanador",
        "email": "programador.angel@gmail.com",
        "createdAt": "2025-02-17T19:06:08.478Z",
        "isActive": true,
        "userId": "660b4183-5161-45d8-afbd-43f40dc7ff2f",
        "memberId": "5b79c546-68c1-4454-8b4f-4fb013daf582",
        "lastLogin": "2025-12-15T10:23:16.992Z",
        "policies": {
          "privacyPolicy": {
            "accepted": true,
            "version": "1.0.0",
            "acceptedAt": "2025-11-27T17:56:14.392Z",
          },
          "sensitiveDataPolicy": {
            "accepted": true,
            "version": "1.0.0",
            "acceptedAt": "2025-11-27T17:56:14.392Z",
          },
        },
        "isSuperUser": false,
        "church": {
          "churchId": "d6a20217-36a7-4520-99b3-f9a212191687",
          "name": "IPUB Santana de parnaiba",
        },
        "roles": ["MEMBER"],
        "token": "test-token",
      };

      final model = AuthSessionModel.fromJson(json);

      expect(model.token, 'test-token');
      expect(model.name, 'Angel Vicente Bejarano Afanador');
      expect(model.email, 'programador.angel@gmail.com');
      expect(model.churchId, 'd6a20217-36a7-4520-99b3-f9a212191687');
      expect(model.churchName, 'IPUB Santana de parnaiba');
      expect(model.lastLogin, '2025-12-15T10:23:16.992Z');
      expect(model.isSuperUser, false);
      expect(model.memberId, '5b79c546-68c1-4454-8b4f-4fb013daf582');
      expect(model.roles, contains('MEMBER'));
      expect(model.policies.privacyPolicy.accepted, true);
    });

    test('parses from JSON with legacy flat churchId if present', () {
      final json = {
        'token': 'test-token',
        'name': 'Test User',
        'email': 'test@example.com',
        'createdAt': '2024-01-15',
        'isActive': true,
        'userId': 'user-123',
        'churchId': 'church-123', // Flat structure
        'roles': ['ADMIN'],
      };

      final model = AuthSessionModel.fromJson(json);

      expect(model.churchId, 'church-123');
      expect(model.churchName, '');
    });

    test('toJson serializes correctly with nested church object', () {
      final model = AuthSessionModel(
        churchId: "123",
        churchName: "Test Church",
        token: "token",
        name: "Test User",
        email: "test@test.com",
        createdAt: "now",
        isActive: true,
        userId: "user123",
        roles: ["ADMIN"],
        lastLogin: "today",
        isSuperUser: true,
        memberId: "member-1",
      );

      final json = model.toJson();

      expect(json['church']['churchId'], "123");
      expect(json['church']['name'], "Test Church");
      expect(json['lastLogin'], "today");
      expect(json['isSuperUser'], true);
      expect(json['memberId'], "member-1");
    });

    test('needsPolicyAcceptance returns true when policies not accepted', () {
      final model = AuthSessionModel(
        token: 'test-token',
        name: 'Test User',
        email: 'test@example.com',
        createdAt: '2024-01-15',
        isActive: true,
        userId: 'user-123',
        churchId: 'church-123',
        roles: ['ADMIN'],
        policies: PolicyAcceptanceModel.empty(),
      );

      expect(model.needsPolicyAcceptance(), true);
    });

    test(
      'needsPolicyAcceptance returns false when all policies accepted with current version',
      () {
        final model = AuthSessionModel(
          token: 'test-token',
          name: 'Test User',
          email: 'test@example.com',
          createdAt: '2024-01-15',
          isActive: true,
          userId: 'user-123',
          churchId: 'church-123',
          roles: ['ADMIN'],
          policies: PolicyAcceptanceModel(
            privacyPolicy: PolicyAcceptanceItem(
              accepted: true,
              version: PolicyConfig.privacyPolicyVersion,
              acceptedAt: DateTime.now(),
            ),
            sensitiveDataPolicy: PolicyAcceptanceItem(
              accepted: true,
              version: PolicyConfig.sensitiveDataPolicyVersion,
              acceptedAt: DateTime.now(),
            ),
          ),
        );

        expect(model.needsPolicyAcceptance(), false);
      },
    );

    test('copyWith preserves new fields', () {
      final original = AuthSessionModel(
        token: 'test-token',
        name: 'Test User',
        email: 'test@example.com',
        createdAt: '2024-01-15',
        isActive: true,
        userId: 'user-123',
        churchId: 'church-123',
        churchName: 'Original Church',
        roles: ['ADMIN'],
        lastLogin: 'yesterday',
        isSuperUser: true,
        memberId: 'm1',
      );

      final copied = original.copyWith(name: 'New Name');

      expect(copied.name, 'New Name');
      expect(copied.churchName, 'Original Church');
      expect(copied.lastLogin, 'yesterday');
      expect(copied.isSuperUser, true);
      expect(copied.memberId, 'm1');
    });

    test('copyWith updates new fields', () {
      final original = AuthSessionModel(
        token: 'test-token',
        name: 'Test User',
        email: 'test@example.com',
        createdAt: '2024-01-15',
        isActive: true,
        userId: 'user-123',
        churchId: 'church-123',
        roles: ['ADMIN'],
      );

      final copied = original.copyWith(
        churchName: 'New Church',
        lastLogin: 'now',
        isSuperUser: true,
      );

      expect(copied.churchName, 'New Church');
      expect(copied.lastLogin, 'now');
      expect(copied.isSuperUser, true);
    });
  });
}
