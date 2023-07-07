import 'package:flutter/material.dart';
import 'package:minecords/screens/src/methods.dart';

class ShowDetials extends StatelessWidget {
  String name, worldName, keywords, dimension;
  int x, y, z;
  ShowDetials({
    super.key,
    required this.name,
    required this.worldName,
    required this.keywords,
    required this.dimension,
    required this.x,
    required this.y,
    required this.z,
  });

  @override
  Widget build(BuildContext context) {
    SizedBox copyIcon = SizedBox(
      height: 25,
      width: 25,
      child: IconButton(
        onPressed: () => onCopyPressed(x, y, z, context),
        icon: const Icon(
          Icons.copy,
          size: 16,
        ),
      ),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          showText("Name", name, context, null),
          showText("world name", worldName, context, null),
          showText("keywords", keywords, context, null),
          showText(
            "x y z",
            "$x $y $z",
            context,
            copyIcon,
          ),
          showText("Dimension", dimension, context, null),
        ],
      ),
    );
  }

  Visibility showText(
      String label, String text, BuildContext context, Widget? extra) {
    return Visibility(
      visible: text.isNotEmpty,
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$label:",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                        Text(text),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          extra ?? const SizedBox()
        ],
      ),
    );
  }
}
