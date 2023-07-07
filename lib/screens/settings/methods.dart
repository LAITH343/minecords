import 'package:flutter/material.dart';
import 'package:minecords/config.dart';
import 'package:minecords/modules/settings.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/screens/src/widgets.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

/// Function to add a database connection
Future<bool> addConnection(
  BuildContext context,
  TextEditingController host,
  TextEditingController username,
  TextEditingController password,
  TextEditingController databaseName,
  TextEditingController port,
) async {
  // Check if any of the required fields are empty or if the port value is not a valid number
  if (host.text.isEmpty ||
      username.text.isEmpty ||
      password.text.isEmpty ||
      databaseName.text.isEmpty ||
      port.text.isEmpty ||
      num.tryParse(port.text) == null) {
    // Show an error message if any of the fields are empty or the port value is invalid
    showMessage(context, "all Fileds required");
    return false;
  }

  // Create a ConnectionSettings object with the entered values
  ConnectionSettings settings = ConnectionSettings(
    host: host.text.trim(),
    port: int.parse(port.text.trim()),
    user: username.text.trim(),
    password: password.text.trim(),
    db: databaseName.text.trim(),
  );

  try {
    // Test the online connection using the provided settings
    bool connectionResult = await dbManager.testOnlineConnection(settings);
    if (!connectionResult) {
      // Show an error message if the connection test fails
      showMessage(context, "failed to connect");
      return false;
    }

    // Access the Cords provider using the Provider package
    final cordsProvider = Provider.of<Cords>(context, listen: false);

    // Set the online database settings in the app
    await setOnlineDBSettings(
      host.text,
      username.text,
      password.text,
      databaseName.text,
      int.parse(port.text),
    );

    // Initialize the database manager with the new settings
    await dbManager.initDatabase();

    // Retrieve all cords from the database and update the provider
    bool setResult =
        await cordsProvider.setItems(await dbManager.getAllCords());

    // Show a success message indicating that the connection was established
    showMessage(context, "connected to database successfully");
    return true;
  } catch (e) {
    // Show an error message if an exception occurs during the connection process
    showMessage(context, "failed to connect");
    return false;
  }
}

/// Function to remove a database connection
Future<bool> removeConnection(
  BuildContext context,
  TextEditingController host,
  TextEditingController username,
  TextEditingController password,
  TextEditingController databaseName,
  TextEditingController port,
) async {
  // Remove the stored settings for the database connection
  removeSettings();

  // Re-initialize the database manager with the default settings
  await dbManager.initDatabase();
  final cordsProvider = Provider.of<Cords>(context, listen: false);
  await cordsProvider.setItems(await dbManager.getAllCords());

  // Clear the text fields
  host.clear();
  username.clear();
  password.clear();
  databaseName.clear();
  port.clear();
  return true;
}
