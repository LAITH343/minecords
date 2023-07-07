import 'package:flutter/material.dart';
import 'package:minecords/screens/add/add_screen.dart';
import 'package:minecords/screens/home/methods.dart';
import 'package:minecords/screens/home/src/app_bar.dart';
import 'package:minecords/screens/home/src/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),
      body: const homeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushScreen(context, const AddItem()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
