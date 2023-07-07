import 'package:flutter/material.dart';
import 'package:minecords/screens/add/src/app_bar.dart';
import 'package:minecords/screens/add/src/body.dart';

class AddItem extends StatelessWidget {
  const AddItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: addAppBar(),
      body: const AddBody(),
    );
  }
}
