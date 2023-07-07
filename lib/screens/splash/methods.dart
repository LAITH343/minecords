import 'package:flutter/material.dart';
import 'package:minecords/config.dart';
import 'package:minecords/modules/database.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/screens/main.dart';
import 'package:minecords/screens/src/widgets.dart';
import 'package:provider/provider.dart';

/// Function to initialize the database
initDB(BuildContext context) async {
  // Initialize the database and get the result indicating the type of database (local or online)
  DataBaseType? result = await dbManager.initDatabase();

  if (result == null) {
    // Show an error message if the database initialization fails
    showMessage(context, "failed to initialize database");
    return;
  }

  // Access the Cords provider using the Provider package
  final cordsProvider = Provider.of<Cords>(context, listen: false);

  // Retrieve all cords from the database and update the provider
  cordsProvider.setItems(await dbManager.getAllCords());

  if (result == DataBaseType.local) {
    // Show a message indicating that the app is using a local database
    showMessage(context, "Using local database");
  } else {
    // Show a message indicating that the app is using an online database
    showMessage(context, "Using online database");
  }

  // Change the screen and navigate to the HomeScreen
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => MainScreen()),
  );
}
