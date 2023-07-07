import 'package:flutter/material.dart';
import 'package:minecords/config.dart';

class Cord {
  int id;
  int x, y, z;
  String name, worldName, keywords, dimension;
  Cord({
    required this.id,
    required this.name,
    required this.keywords,
    required this.worldName,
    required this.dimension,
    required this.x,
    required this.y,
    required this.z,
  });
}

class Cords extends ChangeNotifier {
  List<Cord> items = [];
  bool filtered = false;
  Future<bool> setItems(List<Cord> newItems) async {
    items = newItems;
    notifyListeners();
    return true;
  }

  Future<bool> addItem(Cord item) async {
    bool result = await dbManager.addCord(item);
    if (result) {
      items = await dbManager.getAllCords();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeItem(int id) async {
    bool result = await dbManager.deleteCord(id);
    if (result) {
      items = await dbManager.getAllCords();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  bool filterItems(List<Cord> filteredItems) {
    items = filteredItems;
    filtered = true;
    notifyListeners();
    return true;
  }

  Future<bool> removeFilter() async {
    List<Cord> result = await dbManager.getAllCords();
    if (result.isNotEmpty) {
      items = result;
      filtered = false;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
