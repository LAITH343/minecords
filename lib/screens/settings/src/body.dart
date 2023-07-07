import 'package:flutter/material.dart';
import 'package:minecords/config.dart';
import 'package:minecords/modules/database.dart';
import 'package:minecords/screens/settings/methods.dart';
import 'package:minecords/screens/src/widgets.dart';

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  TextEditingController host = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController databaseName = TextEditingController();
  TextEditingController port = TextEditingController();

  bool settingsFound = false;

  Widget _connnectDisconnect = Text(
    dbManager.dbType == DataBaseType.online ? "disconnect" : "connect",
  );

  checkSettings() async {
    if (dbManager.dbType == DataBaseType.online &&
        dbManager.sqlConnectionSettings != null) {
      setState(() {
        host.text = dbManager.sqlConnectionSettings!.host;
        username.text = dbManager.sqlConnectionSettings!.user.toString();
        password.text = dbManager.sqlConnectionSettings!.password.toString();
        databaseName.text = dbManager.sqlConnectionSettings!.db.toString();
        port.text = dbManager.sqlConnectionSettings!.port.toString();
        settingsFound = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkSettings();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            textFiled("Host", host, width),
            textFiled("username", username, width),
            textFiled("password", password, width),
            textFiled("database name", databaseName, width),
            textFiled("port", port, width),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _connnectDisconnect = loadingWidget;
                });
                bool prevSettings = settingsFound;
                bool result = dbManager.dbType == DataBaseType.online
                    ? await removeConnection(
                        context,
                        host,
                        username,
                        password,
                        databaseName,
                        port,
                      )
                    : await addConnection(
                        context,
                        host,
                        username,
                        password,
                        databaseName,
                        port,
                      );
                setState(() {
                  _connnectDisconnect = Text(
                    dbManager.dbType == DataBaseType.local
                        ? "connect"
                        : "disconnect",
                  );
                });
              },
              child: SizedBox(
                width: 100,
                height: 30,
                child: Center(child: _connnectDisconnect),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile textFiled(
      String label, TextEditingController controller, double width) {
    return ListTile(
      title: Text(label),
      trailing: SizedBox(
        height: 40,
        width: width * .4,
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ),
    );
  }
}
