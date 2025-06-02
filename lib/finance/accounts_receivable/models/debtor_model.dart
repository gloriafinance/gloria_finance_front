enum DebtorType { MEMBER, EXTERNAL }

extension DebtorTypeExtension on DebtorType {
  String get apiValue {
    switch (this) {
      case DebtorType.MEMBER:
        return 'MEMBER';
      case DebtorType.EXTERNAL:
        return 'EXTERNAL';
    }
  }

  String get friendlyName {
    switch (this) {
      case DebtorType.MEMBER:
        return 'Membro';
      case DebtorType.EXTERNAL:
        return 'Externo';
    }
  }
}

class DebtorModel {
  final String debtorType;
  final String debtorDNI;
  final String name;
  final String phone;
  final String email;
  final String address;

  DebtorModel({
    required this.debtorType,
    required this.debtorDNI,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  DebtorModel.fromMap(Map<String, dynamic> map)
    : debtorType = map['debtorType'],
      debtorDNI = map['debtorDNI'],
      name = map['name'],
      phone = map['phone'] ?? '',
      email = map['email'] ?? '',
      address = map['address'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'debtorType': debtorType,
      'debtorDNI': debtorDNI,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  getDebtorType() {
    var d = DebtorType.values.firstWhere(
      (e) => e.apiValue == debtorType,
      orElse: () => DebtorType.MEMBER,
    );

    return d.friendlyName;
  }
}
