import 'package:flutter/material.dart';
import 'package:minecords/config.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/provider/search.dart';
import 'package:provider/provider.dart';

bool isFound(Cord key, List<Cord> items) {
  for (Cord item in items) {
    if (item.id == key.id) return true;
  }
  return false;
}

/// search for [keys] in name, world name and keywords database tables
///
/// return list of matched words as [Cord]
Future<List<Cord>> search(String keys) async {
  List<Cord> items = [];
  for (String key in keys.split(',')) {
    String k = key.trim();
    if (k.isEmpty) continue;
    // ignore: avoid_single_cascade_in_expression_statements
    await dbManager.filterCords(k, "", "", "", -1, -1, -1)
      ..forEach((element) {
        !isFound(element, items) ? items.add(element) : null;
      });
    // ignore: avoid_single_cascade_in_expression_statements
    await dbManager.filterCords("", k, "", "", -1, -1, -1)
      ..forEach((element) {
        !isFound(element, items) ? items.add(element) : null;
      });
    // ignore: avoid_single_cascade_in_expression_statements
    await dbManager.filterCords("", "", k, "", -1, -1, -1)
      ..forEach((element) {
        !isFound(element, items) ? items.add(element) : null;
      });
    // ignore: avoid_single_cascade_in_expression_statements
    await dbManager.filterCords("", "", "", k, -1, -1, -1)
      ..forEach((element) {
        !isFound(element, items) ? items.add(element) : null;
      });
  }
  return items;
}

void onSearchTextChanged(
    TextEditingController searchController, BuildContext context) async {
  final searchProvider = Provider.of<SearchProvider>(context, listen: false);
  if (searchController.text.isEmpty && searchProvider.items.isNotEmpty) {
    searchProvider.clearItems();
  }

  searchProvider.setItems(await search(searchController.text));

  if (searchController.text.isEmpty && searchProvider.items.isNotEmpty) {
    searchProvider.clearItems();
  }
}
