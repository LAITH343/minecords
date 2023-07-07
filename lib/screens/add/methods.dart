import 'package:flutter/widgets.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/screens/src/widgets.dart';
import 'package:provider/provider.dart';

/// Function called when the save button is pressed
Future<bool> onSavePressed(
  BuildContext context,
  TextEditingController name,
  TextEditingController worldName,
  TextEditingController keywords,
  String dimension,
  TextEditingController x,
  TextEditingController y,
  TextEditingController z,
) async {
  // Check if any of the required fields (name, x, y, z) are empty or not the right type
  if (name.text.isEmpty ||
      x.text.isEmpty ||
      num.tryParse(x.text) == null ||
      y.text.isEmpty ||
      num.tryParse(y.text) == null ||
      z.text.isEmpty ||
      num.tryParse(z.text) == null) {
    // Show an error message if any of the required fields are empty
    showMessage(context, "the name, x, y, z values cannot be empty");
    return false; // Return false to indicate that the saving process failed
  }

  // Access the Cords provider using the Provider package
  final cordsProvider = Provider.of<Cords>(context, listen: false);

  // Create a new Cord object with the values entered by the user
  bool result = await cordsProvider.addItem(
    Cord(
      id: -1,
      name: name.text,
      keywords: keywords.text,
      worldName: worldName.text,
      dimension: dimension,
      x: double.parse(x.text).toInt(),
      y: double.parse(y.text).toInt(),
      z: double.parse(z.text).toInt(),
    ),
  );

  // Clear the text fields after saving the cord
  name.clear();
  worldName.clear();
  keywords.clear();
  x.clear();
  y.clear();
  z.clear();

  // Check the result of adding the cord to the provider
  if (result) {
    // Show a success message if the cord was added successfully
    showMessage(context, "cords added");
    return true; // Return true to indicate that the saving process was successful
  } else {
    // Show an error message if the cord could not be added
    showMessage(context, "failed to add cords");
    return false; // Return false to indicate that the saving process failed
  }
}
