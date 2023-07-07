import 'package:flutter/material.dart';
import 'package:minecords/screens/settings/src/body.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("online sql settings"),
      ),
      body: const SettingsBody(),
    );
  }
}
