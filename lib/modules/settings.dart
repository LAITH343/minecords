import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Sets the connection settings for the online database by creating a YAML file.
///
/// The [dbHost] parameter specifies the host of the database.
/// The [dbUsername] parameter specifies the username for accessing the database.
/// The [dbPassword] parameter specifies the password for accessing the database.
/// The [dbName] parameter specifies the name of the database.
/// The [dbPort] parameter specifies the port number for the database connection.
///
/// Returns `true` if the settings are successfully saved, `false` otherwise.
Future<bool> setOnlineDBSettings(
  String dbHost,
  String dbUsername,
  String dbPassword,
  String dbName,
  int dbPort,
) async {
  try {
    Directory appDir = await getApplicationDocumentsDirectory();
    File settings = File("${appDir.path}/minecords/sql_connection.yaml")
      ..createSync(recursive: true);
    
    String cfg = '''host: $dbHost
username: $dbUsername
password: $dbPassword
db_name: $dbName
port: $dbPort
''';
    settings.writeAsStringSync(cfg, mode: FileMode.write);
    
    return true;
  } catch (e) {
    // Error occurred while setting the online database settings
    return false;
  }
}

/// Removes the online database connection settings by deleting the YAML file.
///
/// Returns `true` if the settings are successfully removed, `false` otherwise.
Future<bool> removeSettings() async {
  try {
    Directory appDir = await getApplicationDocumentsDirectory();
    File settings = File("${appDir.path}/minecords/sql_connection.yaml");
    settings.deleteSync();
    
    return true;
  } catch (e) {
    // Error occurred while removing the settings
    return false;
  }
}
