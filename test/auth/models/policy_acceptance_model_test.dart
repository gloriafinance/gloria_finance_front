import 'package:church_finance_bk/features/auth/models/policy_acceptance_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PolicyAcceptanceItem', () {
    test('creates empty item when no data provided', () {
      final item = PolicyAcceptanceItem.empty();

      expect(item.accepted, false);
      expect(item.version, isNull);
      expect(item.acceptedAt, isNull);
    });

    test('parses from JSON correctly', () {
      final json = {
        'accepted': true,
        'version': '1.0.0',
        'acceptedAt': '2024-01-15T10:30:00.000Z',
      };

      final item = PolicyAcceptanceItem.fromJson(json);

      expect(item.accepted, true);
      expect(item.version, '1.0.0');
      expect(item.acceptedAt, isNotNull);
      expect(item.acceptedAt!.year, 2024);
      expect(item.acceptedAt!.month, 1);
      expect(item.acceptedAt!.day, 15);
    });

    test('handles null JSON gracefully', () {
      final item = PolicyAcceptanceItem.fromJson(null);

      expect(item.accepted, false);
      expect(item.version, isNull);
      expect(item.acceptedAt, isNull);
    });

    test('isAcceptedWithVersion returns true for matching version', () {
      final item = PolicyAcceptanceItem(
        accepted: true,
        version: '1.0.0',
        acceptedAt: DateTime.now(),
      );

      expect(item.isAcceptedWithVersion('1.0.0'), true);
    });

    test('isAcceptedWithVersion returns false for different version', () {
      final item = PolicyAcceptanceItem(
        accepted: true,
        version: '1.0.0',
        acceptedAt: DateTime.now(),
      );

      expect(item.isAcceptedWithVersion('2.0.0'), false);
    });

    test('isAcceptedWithVersion returns false when not accepted', () {
      final item = PolicyAcceptanceItem(
        accepted: false,
        version: '1.0.0',
        acceptedAt: DateTime.now(),
      );

      expect(item.isAcceptedWithVersion('1.0.0'), false);
    });

    test('isAcceptedWithVersion returns false when acceptedAt is null', () {
      final item = PolicyAcceptanceItem(
        accepted: true,
        version: '1.0.0',
        acceptedAt: null,
      );

      expect(item.isAcceptedWithVersion('1.0.0'), false);
    });

    test('serializes to JSON correctly', () {
      final acceptedAt = DateTime(2024, 1, 15, 10, 30);
      final item = PolicyAcceptanceItem(
        accepted: true,
        version: '1.0.0',
        acceptedAt: acceptedAt,
      );

      final json = item.toJson();

      expect(json['accepted'], true);
      expect(json['version'], '1.0.0');
      expect(json['acceptedAt'], isNotNull);
    });
  });

  group('PolicyAcceptanceModel', () {
    test('creates empty model', () {
      final model = PolicyAcceptanceModel.empty();

      expect(model.privacyPolicy.accepted, false);
      expect(model.sensitiveDataPolicy.accepted, false);
    });

    test('parses from JSON correctly', () {
      final json = {
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
      };

      final model = PolicyAcceptanceModel.fromJson(json);

      expect(model.privacyPolicy.accepted, true);
      expect(model.privacyPolicy.version, '1.0.0');
      expect(model.sensitiveDataPolicy.accepted, true);
      expect(model.sensitiveDataPolicy.version, '1.0.0');
    });

    test('handles null JSON gracefully', () {
      final model = PolicyAcceptanceModel.fromJson(null);

      expect(model.privacyPolicy.accepted, false);
      expect(model.sensitiveDataPolicy.accepted, false);
    });

    test('handles partial JSON gracefully', () {
      final json = {
        'privacyPolicy': {
          'accepted': true,
          'version': '1.0.0',
          'acceptedAt': '2024-01-15T10:30:00.000Z',
        },
      };

      final model = PolicyAcceptanceModel.fromJson(json);

      expect(model.privacyPolicy.accepted, true);
      expect(model.sensitiveDataPolicy.accepted, false);
    });

    test('areAllPoliciesAccepted returns true when all policies match', () {
      final model = PolicyAcceptanceModel(
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
      );

      expect(
        model.areAllPoliciesAccepted(
          requiredPrivacyVersion: '1.0.0',
          requiredSensitiveDataVersion: '1.0.0',
        ),
        true,
      );
    });

    test(
      'areAllPoliciesAccepted returns false when privacy policy version differs',
      () {
        final model = PolicyAcceptanceModel(
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
        );

        expect(
          model.areAllPoliciesAccepted(
            requiredPrivacyVersion: '2.0.0',
            requiredSensitiveDataVersion: '1.0.0',
          ),
          false,
        );
      },
    );

    test(
      'areAllPoliciesAccepted returns false when sensitive data policy version differs',
      () {
        final model = PolicyAcceptanceModel(
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
        );

        expect(
          model.areAllPoliciesAccepted(
            requiredPrivacyVersion: '1.0.0',
            requiredSensitiveDataVersion: '2.0.0',
          ),
          false,
        );
      },
    );

    test(
      'areAllPoliciesAccepted returns false when any policy is not accepted',
      () {
        final model = PolicyAcceptanceModel(
          privacyPolicy: PolicyAcceptanceItem(
            accepted: false,
            version: '1.0.0',
            acceptedAt: DateTime.now(),
          ),
          sensitiveDataPolicy: PolicyAcceptanceItem(
            accepted: true,
            version: '1.0.0',
            acceptedAt: DateTime.now(),
          ),
        );

        expect(
          model.areAllPoliciesAccepted(
            requiredPrivacyVersion: '1.0.0',
            requiredSensitiveDataVersion: '1.0.0',
          ),
          false,
        );
      },
    );

    test('serializes to JSON correctly', () {
      final model = PolicyAcceptanceModel(
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
      );

      final json = model.toJson();

      expect(json['privacyPolicy'], isA<Map<String, dynamic>>());
      expect(json['sensitiveDataPolicy'], isA<Map<String, dynamic>>());
      expect(json['privacyPolicy']['accepted'], true);
      expect(json['sensitiveDataPolicy']['accepted'], true);
    });
  });
}
