enum CostCenterCategory { ESPECIAL_PROJECT, MINISTRIES, OPERATIONS }

class CostCenterModel {
  final bool active;
  final String churchId;
  final String costCenterId;
  final String name;
  final String description;
  final String category;
  final CostCenterManager responsible;

  CostCenterModel({
    required this.active,
    required this.churchId,
    required this.costCenterId,
    required this.name,
    required this.description,
    required this.category,
    required this.responsible,
  });

  CostCenterModel.fromMap(Map<String, dynamic> map)
      : active = map['active'],
        churchId = map['churchId'],
        costCenterId = map['costCenterId'],
        name = map['name'],
        description = map['description'],
        category = map['category'],
        responsible = CostCenterManager.fromJson(map['responsible']);

  Map<String, dynamic> toJson() => {
        'active': active,
        'churchId': churchId,
        'costCenterId': costCenterId,
        'name': name,
        'description': description,
        'category': category,
        'responsible': responsible.toJson(),
      };
}

class CostCenterManager {
  final String name;
  final String email;
  final String phone;

  CostCenterManager({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory CostCenterManager.fromJson(Map<String, dynamic> json) {
    return CostCenterManager(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
      };
}
