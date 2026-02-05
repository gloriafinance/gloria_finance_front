import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';

class CostCenterFormState {
  final bool makeRequest;
  final String costCenterId;
  final String name;
  final String description;
  final CostCenterCategory? category;
  final bool active;
  final String? responsibleMemberId;
  final String? responsibleMemberName;

  const CostCenterFormState({
    required this.makeRequest,
    required this.costCenterId,
    required this.name,
    required this.description,
    required this.category,
    required this.active,
    required this.responsibleMemberId,
    required this.responsibleMemberName,
  });

  factory CostCenterFormState.init() {
    return const CostCenterFormState(
      makeRequest: false,
      costCenterId: '',
      name: '',
      description: '',
      category: null,
      active: true,
      responsibleMemberId: null,
      responsibleMemberName: null,
    );
  }

  factory CostCenterFormState.fromModel(CostCenterModel model) {
    final responsible = model.responsible;
    String? displayName;

    if (responsible != null && responsible.name.isNotEmpty) {
      displayName =
          responsible.email.isNotEmpty
              ? '${responsible.name} • ${responsible.email}'
              : responsible.name;
    }

    return CostCenterFormState(
      makeRequest: false,
      costCenterId: model.costCenterId,
      name: model.name,
      description: model.description,
      category: model.category,
      active: model.active,
      responsibleMemberId:
          model.responsibleMemberId ?? model.responsible?.memberId,
      responsibleMemberName: displayName,
    );
  }

  CostCenterFormState copyWith({
    bool? makeRequest,
    String? costCenterId,
    String? name,
    String? description,
    CostCenterCategory? category,
    bool? active,
    String? responsibleMemberId,
    String? responsibleMemberName,
  }) {
    return CostCenterFormState(
      makeRequest: makeRequest ?? this.makeRequest,
      costCenterId: costCenterId ?? this.costCenterId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      active: active ?? this.active,
      responsibleMemberId: responsibleMemberId ?? this.responsibleMemberId,
      responsibleMemberName:
          responsibleMemberName ?? this.responsibleMemberName,
    );
  }

  bool get isEdit => costCenterId.isNotEmpty;

  Map<String, dynamic> toPayload(String churchId) {
    final Map<String, dynamic> payload = {
      'costCenterId': costCenterId,
      'active': active,
      'name': name,
      'description': description,
      'churchId': churchId,
    };

    if (category != null) {
      payload['category'] = category!.apiValue;
    }

    if (responsibleMemberId != null) {
      payload['responsibleMemberId'] = responsibleMemberId;
    }

    return payload;
  }
}
