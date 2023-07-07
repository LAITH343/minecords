import 'package:flutter/material.dart';
import 'package:minecords/config.dart';
import 'package:minecords/modules/database.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/screens/settings/settings.dart';
import 'package:provider/provider.dart';

AppBar homeAppBar(BuildContext context) => AppBar(
      automaticallyImplyLeading: false,
      title: const Text("MineCords"),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<Cords>(
            builder: (context, value, child) => IconButton(
              tooltip: "setting online sql database",
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              ),
              icon: Icon(
                dbManager.dbType == DataBaseType.local
                    ? Icons.cloud_off
                    : Icons.cloud_done,
              ),
            ),
          ),
        ),
      ],
    );
