import 'package:gloria_finance/features/erp/settings/members/models/member_model.dart';
import 'package:flutter/material.dart';

import '../services/member_list_service.dart';

class MemberAllStore extends ChangeNotifier {
  var service = MemberListService();

  // List of all members
  List<MemberModel> members = [];

  // Get all members
  List<MemberModel> getMembers() {
    return members;
  }

  searchAllMember() async {
    try {
      members = await service.members();
      notifyListeners();
    } catch (e) {
      print("ERRROR ${e}");
    }
  }
}
