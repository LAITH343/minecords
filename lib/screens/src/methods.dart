
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/screens/src/widgets.dart';
import 'package:provider/provider.dart';

/// Function called when the copy button is pressed for a specific set of coordinates
onCopyPressed(int x, int y, int z, BuildContext context) {
  // Copy the coordinates to the clipboard using the Clipboard package
  Clipboard.setData(ClipboardData(text: "$x $y $z"));
  // Show a message indicating that the coordinates have been copied
  showMessage(context, "coordinates copied");
}

/// Function called when the delete icon is pressed for a specific cord
Future<bool> onDeleteIconPressed(BuildContext context, int id) async {
  final p = Provider.of<Cords>(context, listen: false);
  // Remove the cord from the database using the removeItem method from the Cords provider
  return await p.removeItem(id);
}
