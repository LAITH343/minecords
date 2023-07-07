import 'package:flutter/material.dart';
import 'package:minecords/provider/cords.dart';

class SearchProvider extends ChangeNotifier {
  List<Cord> items = [];

  bool setItems(List<Cord> newItems) {
    if (newItems != items) {
      items = newItems;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool clearItems() {
    items.clear();
    notifyListeners();
    return true;
  }
}
