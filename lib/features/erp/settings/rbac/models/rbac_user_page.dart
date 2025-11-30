import 'rbac_user_model.dart';

class RbacUserPage {
  const RbacUserPage({
    required this.users,
    required this.page,
    required this.total,
    this.nextPage,
  });

  final List<RbacUserModel> users;
  final int page;
  final int total;
  final int? nextPage;

  bool get hasMore => nextPage != null;
}
