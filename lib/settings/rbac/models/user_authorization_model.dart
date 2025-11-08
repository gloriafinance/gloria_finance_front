class UserAuthorizationModel {
  const UserAuthorizationModel({
    required this.roles,
    required this.permissionCodes,
  });

  factory UserAuthorizationModel.fromJson(Map<String, dynamic> json) {
    final roles = (json['roles'] as List?)?.map((role) => role.toString()).toList() ?? const [];
    final permissions =
        (json['permissions'] as List?)?.map((permission) => permission.toString()).toList() ??
        const [];

    return UserAuthorizationModel(
      roles: roles,
      permissionCodes: permissions,
    );
  }

  final List<String> roles;
  final List<String> permissionCodes;
}
