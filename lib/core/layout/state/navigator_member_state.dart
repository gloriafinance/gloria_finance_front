import 'package:flutter/material.dart';

class NavigatorMemberNotifier extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndexTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
