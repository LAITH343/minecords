import 'package:flutter/material.dart';
import 'package:minecords/provider/search.dart';
import 'package:minecords/screens/search/methods.dart';
import 'package:minecords/screens/src/item.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final searchProvider = Provider.of<SearchProvider>(context, listen: false); 
    searchProvider.items = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: (_) => onSearchTextChanged(searchController, context),
          decoration: const InputDecoration(
            hintText: "type here",
            border: InputBorder.none,
          ),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, value, child) => Visibility(
          visible: value.items.isNotEmpty,
          replacement: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "search by name, world name, keywords and dimension. To search by multi Keys(words) sperate them by ',' for example: 'my world, farm' this will get all items that has 'my world' or 'farm'",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          child: ItemsCardGenerator(items: value.items),
        ),
      ),
    );
  }
}
