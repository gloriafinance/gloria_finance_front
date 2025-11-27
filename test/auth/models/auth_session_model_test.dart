import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/models/policy_acceptance_model.dart';
import 'package:church_finance_bk/auth/models/policy_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthSessionModel', () {
    test('creates empty model', () {
      final model = AuthSessionModel.empty();

      expect(model.token, '');
      expect(model.name, '');
      expect(model.policies.privacyPolicy.accepted, false);
    });

    test('parses from JSON with policies', () {
      final json = {
        'token': 'test-token',
        'name': 'Test User',
        'email': 'test@example.com',
        'createdAt': '2024-01-15',
        'isActive': true,
        'userId': 'user-123',
        'churchId': 'church-123',
        'roles': ['ADMIN'],
        'policies': {
          'privacyPolicy': {
            'accepted': true,
            'version': '1.0.0',
            'acceptedAt': '2024-01-15T10:30:00.000Z',
          },
          'sensitiveDataPolicy': {
            'accepted': true,
            'version': '1.0.0',
            'acceptedAt': '2024-01-15T10:30:00.000Z',
          },
        },
      };

      final model = AuthSessionModel.fromJson(json);

      expect(model.token, 'test-token');
      expect(model.name, 'Test User');
      expect(model.policies.privacyPolicy.accepted, true);
      expect(model.policies.privacyPolicy.version, '1.0.0');
      expect(model.policies.sensitiveDataPolicy.accepted, true);
    });

    test('parses from JSON without policies field', () {
      final json = {
        'token': 'test-token',
        'name': 'Test User',
        'email': 'test@example.com',
        'createdAt': '2024-01-15',
        'isActive': true,
        'userId': 'user-123',
        'churchId': 'church-123',
        'roles': ['ADMIN'],
      };

      final model = AuthSessionModel.fromJson(json);

      expect(model.token, 'test-token');
      expect(model.policies.privacyPolicy.accepted, false);
      expect(model.policies.sensitiveDataPolicy.accepted, false);
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
    });

    test('needsPolicyAcceptance returns true when version is outdated', () {
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
            version: '0.9.0', // Outdated version
            acceptedAt: DateTime.now(),
          ),
          sensitiveDataPolicy: PolicyAcceptanceItem(
            accepted: true,
            version: PolicyConfig.sensitiveDataPolicyVersion,
            acceptedAt: DateTime.now(),
          ),
        ),
      );

      expect(model.needsPolicyAcceptance(), true);
    });

    test('copyWith preserves policies when not provided', () {
      final original = AuthSessionModel(
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
            version: '1.0.0',
            acceptedAt: DateTime.now(),
          ),
          sensitiveDataPolicy: PolicyAcceptanceItem(
            accepted: true,
            version: '1.0.0',
            acceptedAt: DateTime.now(),
          ),
        ),
      );

      final copied = original.copyWith(name: 'New Name');

      expect(copied.name, 'New Name');
      expect(copied.policies.privacyPolicy.accepted, true);
      expect(copied.policies.privacyPolicy.version, '1.0.0');
    });

    test('copyWith updates policies when provided', () {
      final original = AuthSessionModel(
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

      final newPolicies = PolicyAcceptanceModel(
        privacyPolicy: PolicyAcceptanceItem(
          accepted: true,
          version: '2.0.0',
          acceptedAt: DateTime.now(),
        ),
        sensitiveDataPolicy: PolicyAcceptanceItem(
          accepted: true,
          version: '2.0.0',
          acceptedAt: DateTime.now(),
        ),
      );

      final copied = original.copyWith(policies: newPolicies);

      expect(copied.policies.privacyPolicy.accepted, true);
      expect(copied.policies.privacyPolicy.version, '2.0.0');
    });

    test('toJson includes policies', () {
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
            version: '1.0.0',
            acceptedAt: DateTime(2024, 1, 15),
          ),
          sensitiveDataPolicy: PolicyAcceptanceItem(
            accepted: true,
            version: '1.0.0',
            acceptedAt: DateTime(2024, 1, 15),
          ),
        ),
      );

      final json = model.toJson();

      expect(json['policies'], isA<Map<String, dynamic>>());
      expect(json['policies']['privacyPolicy']['accepted'], true);
      expect(json['policies']['sensitiveDataPolicy']['accepted'], true);
    });
  });
}
