import 'package:ditonton/common/home_tab_enum.dart';
import 'package:flutter/foundation.dart';

class HomeTabNotifier extends ChangeNotifier {
  HomeTab _currentTab = HomeTab.movie;

  HomeTab get currentTab => _currentTab;

  void setTab(HomeTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }
}
