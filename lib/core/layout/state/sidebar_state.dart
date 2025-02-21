import 'package:flutter/cupertino.dart';

class SidebarNotifier extends ChangeNotifier {
  bool _isSidebarVisible = true;

  bool get isSidebarVisible => _isSidebarVisible;

  int _expandedIndex = -1;

  int get expandedIndex => _expandedIndex;

  void setExpanded(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = -1; // Collapse if already expanded
    } else {
      _expandedIndex = index;
    }
    notifyListeners();
  }

  void toggle() {
    _isSidebarVisible = !_isSidebarVisible;
    notifyListeners();
  }
}
