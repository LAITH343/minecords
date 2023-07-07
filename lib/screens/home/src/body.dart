import 'package:flutter/material.dart';
import 'package:minecords/config.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/screens/src/item.dart';
import 'package:provider/provider.dart';

class homeBody extends StatelessWidget {
  const homeBody({
    super.key,
  });

  Future<bool> getItems(BuildContext context) async {
    final cordsProvider = Provider.of<Cords>(context, listen: false);
    return await cordsProvider.setItems(await dbManager.getAllCords());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cords>(
      builder: (context, value, child) => Visibility(
        visible: value.items.isNotEmpty,
        replacement: Center(
          child: RefreshIndicator(
            onRefresh: () async {
              await getItems(context);
              return;
            },
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.height / 2) - 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "there's no cords added yet",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await getItems(context);
            return;
          },
          child: ItemsCardGenerator(
            items: value.items,
          ),
        ),
      ),
    );
  }
}
