import 'package:flutter/material.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/screens/src/details_dilog.dart';
import 'package:minecords/screens/src/methods.dart';

class ItemsCardGenerator extends StatelessWidget {
  List<Cord> items;
  ItemsCardGenerator({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: GestureDetector(
            onLongPress: () => onCopyPressed(
              items[index].x,
              items[index].y,
              items[index].z,
              context,
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => Dialog(
                child: ShowDetials(
                  name: items[index].name,
                  worldName: items[index].worldName,
                  keywords: items[index].keywords,
                  dimension: items[index].dimension,
                  x: items[index].x,
                  y: items[index].y,
                  z: items[index].z,
                ),
              ),
            ),
            child: Item(
              name: items[index].name,
              worldName: items[index].worldName,
              dimension: items[index].dimension,
              id: items[index].id,
              x: items[index].x,
              y: items[index].y,
              z: items[index].z,
            ),
          ),
        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  String name, worldName, dimension;
  int x, y, z, id;
  Item({
    super.key,
    required this.name,
    required this.worldName,
    required this.dimension,
    required this.id,
    required this.x,
    required this.y,
    required this.z,
  });

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  Widget _delete = const Icon(
    Icons.delete,
    color: Colors.red,
  );
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "${widget.worldName.isNotEmpty ? '${widget.worldName}:' : ''} ${widget.name}"),
      subtitle: Text(
        "${widget.dimension}: x: ${widget.x}, y: ${widget.y}, z: ${widget.z}",
        style: const TextStyle(
          overflow: TextOverflow.fade,
        ),
      ),
      trailing: IconButton(
        onPressed: () async {
          setState(() {
            _delete = const SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          });
          bool result = await onDeleteIconPressed(context, widget.id);
          setState(() {
            _delete = const Icon(
              Icons.delete,
              color: Colors.red,
            );
          });
        },
        icon: SizedBox(
          width: 40,
          height: 30,
          child: Center(child: _delete),
        ),
      ),
    );
  }
}
