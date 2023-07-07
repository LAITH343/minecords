import 'package:flutter/widgets.dart';

class NavBarProvider extends ChangeNotifier {
  int currentIndex = 0;

  bool setIndex(int index) {
    currentIndex = index;
    notifyListeners();
    return true;
  }
}
