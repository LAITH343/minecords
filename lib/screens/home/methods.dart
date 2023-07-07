import 'package:flutter/material.dart';

/// Function to push a new screen onto the navigation stack
pushScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}
