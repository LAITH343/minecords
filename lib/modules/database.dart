import 'dart:io';
import 'package:minecords/provider/cords.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:mysql1/mysql1.dart';
import 'package:yaml/yaml.dart';

enum DataBaseType { local, online }

/// A class that manages the local and online databases.
class DatabaseManager {
  Database? localDB;
  MySqlConnection? onlineDB;
  ConnectionSettings? sqlConnectionSettings;
  bool initialized = false;
  DataBaseType? dbType;

  /// Tests the online database connection using the provided connection settings.
  Future<bool> testOnlineConnection(ConnectionSettings settings) async {
    try {
      await MySqlConnection.connect(settings);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Initializes the database based on whether the local or online database is available.
  /// If the online database is not available, it falls back to the local database.
  Future<DataBaseType?> initDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    if (File("${appDir.path}/minecords/sql_connection.yaml").existsSync()) {
      try {
        return await _initOnlineDataBase(appDir);
      } catch (_) {}
    }
    return await _initLocalDataBase(appDir);
  }

  // Initializes the local database.
  Future<DataBaseType?> _initLocalDataBase(Directory appDir) async {
    Directory("${appDir.path}/minecords").createSync(recursive: true);
    localDB = sqlite3.open("${appDir.path}/minecords/main.db",
        mode: OpenMode.readWriteCreate);
    if (localDB != null) {
      localDB!.execute(
          "CREATE TABLE IF NOT EXISTS cords (id INTEGER PRIMARY KEY AUTOINCREMENT, cordName VARCHAR(25), worldName VARCHAR(25), keywords VARCHAR(100), dimension VARCHAR(9), x INTEGER, y INTEGER, z INTEGER)");
      initialized = true;
      dbType = DataBaseType.local;
      return dbType!;
    } else {}
    return null;
  }

  // Initializes the online database.
  Future<DataBaseType> _initOnlineDataBase(Directory appDir) async {
    final cfgFile = File("${appDir.path}/minecords/sql_connection.yaml");
    if (!cfgFile.existsSync()) {
      throw Exception('SQL connection settings file not found');
    }
    final cfg = loadYaml(await cfgFile.readAsString());
    sqlConnectionSettings ??= ConnectionSettings(
      host: cfg['host'].toString(),
      port: cfg['port'],
      user: cfg['username'].toString(),
      password: cfg['password'].toString(),
      db: cfg['db_name'].toString(),
    );
    onlineDB = await MySqlConnection.connect(sqlConnectionSettings!);
    await onlineDB!.query(
        "CREATE TABLE IF NOT EXISTS cords (id INTEGER NOT NULL auto_increment primary key, cordName VARCHAR(25), worldName VARCHAR(25), keywords VARCHAR(100), dimension VARCHAR(9), x INTEGER, y INTEGER, z INTEGER)");
    initialized = true;
    dbType = DataBaseType.online;
    return dbType!;
  }

  // Retrieves all cords from the local database.
  Future<List<Cord>> _getAllCordsLocal() async {
    if (localDB == null) return [];
    final result = localDB!.select("SELECT * FROM cords");
    if (result.isEmpty) {
      return [];
    }
    final items = result
        .map((row) => Cord(
              id: int.parse(row['id'].toString()),
              name: row['cordName'],
              keywords: row['keywords'],
              worldName: row['worldName'],
              dimension: row['dimension'],
              x: int.parse(row['x'].toString()),
              y: int.parse(row['y'].toString()),
              z: int.parse(row['z'].toString()),
            ))
        .toList();
    return items;
  }

  // Retrieves all cords from the online database.
  Future<List<Cord>> _getAllCordsOnline() async {
    if (onlineDB == null) return [];
    const query = 'SELECT * FROM cords';
    final result = await onlineDB!.query(query);
    if (result.isEmpty) return [];
    final items = result
        .map((row) => Cord(
              id: row['id'] as int,
              name: row['cordName'] as String,
              keywords: row['keywords'] as String,
              worldName: row['worldName'] as String,
              dimension: row['dimension'] as String,
              x: row['x'] as int,
              y: row['y'] as int,
              z: row['z'] as int,
            ))
        .toList();
    return items;
  }

  /// Retrieves all cords from the database based on the selected database type.
  Future<List<Cord>> getAllCords() async {
    if (dbType == DataBaseType.local) {
      return await _getAllCordsLocal();
    } else {
      return _getAllCordsOnline();
    }
  }

  // Adds a new cord to the local database.
  Future<bool> _addCordLocal(Cord newCord) async {
    if (localDB == null) return false;
    try {
      localDB!.execute(
        "INSERT INTO cords (cordName, worldName, keywords, dimension, x, y, z) VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          newCord.name.trim(),
          newCord.worldName.trim(),
          newCord.keywords.trim(),
          newCord.dimension.trim(),
          newCord.x,
          newCord.y,
          newCord.z
        ],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Adds a new cord to the online database.
  Future<bool> _addCordOnline(Cord newCord) async {
    if (onlineDB == null) return false;
    try {
      const query = '''
        INSERT INTO cords (cordName, worldName, keywords, dimension, x, y, z)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''';
      await onlineDB!.query(query, [
        newCord.name.trim(),
        newCord.worldName.trim(),
        newCord.keywords.trim(),
        newCord.dimension.trim(),
        newCord.x,
        newCord.y,
        newCord.z
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Adds a new cord to the database based on the selected database type.
  Future<bool> addCord(Cord newCord) async {
    if (dbType == DataBaseType.local) {
      return await _addCordLocal(newCord);
    } else {
      return await _addCordOnline(newCord);
    }
  }

  // Deletes a cord from the local database.
  Future<bool> _deleteCordLocal(int cordId) async {
    if (localDB == null) return false;
    try {
      localDB!.execute("DELETE FROM cords WHERE id=?", [cordId]);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Deletes a cord from the online database.
  Future<bool> _deleteCordOnline(int cordId) async {
    if (onlineDB == null) return false;
    try {
      const query = 'DELETE FROM cords WHERE id = ?';
      await onlineDB!.query(query, [cordId]);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes a cord from the database based on the selected database type.
  Future<bool> deleteCord(int cordId) async {
    if (dbType == DataBaseType.local) {
      return await _deleteCordLocal(cordId);
    } else {
      return await _deleteCordOnline(cordId);
    }
  }

  // Generates filter keywords based on the provided parameters.
  List<String> _generateFilterKeywords(String? cordName, String? worldName,
      String? keywords, String? dimension, int? x, int? y, int? z) {
    final keyWord = <String>[];
    if (cordName != null) keyWord.add("cordName LIKE '%$cordName%'");
    if (worldName != null) keyWord.add("worldName LIKE '%$worldName%'");
    if (keywords != null) {
      final keys = keywords.split(',').map((e) => e.trim()).toList();
      keyWord.add("keywords LIKE '%${keys.join("%' OR keywords LIKE '%")}%'");
    }
    if (dimension != null) keyWord.add("dimension ='$dimension'");
    if (x != null) keyWord.add("x >= '$x'");
    if (y != null) keyWord.add("y >= '$y'");
    if (z != null) keyWord.add("z >= '$z'");
    return keyWord;
  }

  // Filters cords from the local database based on the provided parameters.
  Future<List<Cord>> _filterByLocal(String cordName, String worldName,
      String keywords, String dimension, int x, int y, int z) async {
    if (localDB == null) return [];
    final keyWords = _generateFilterKeywords(
      cordName.isEmpty ? null : cordName.trim(),
      worldName.isEmpty ? null : worldName.trim(),
      keywords.isEmpty ? null : keywords,
      dimension.isEmpty ? null : dimension,
      x == -1 ? null : x,
      y == -1 ? null : y,
      z == -1 ? null : z,
    );
    final filterCommand =
        "SELECT * FROM cords ${keyWords.isNotEmpty ? "WHERE ${keyWords.join(" AND ")}" : ''}";
    final result = localDB!.select(filterCommand);
    if (result.isEmpty) return [];
    final items = result
        .map((row) => Cord(
              id: int.parse(row['id'].toString()),
              name: row['cordName'],
              keywords: row['keywords'],
              worldName: row['worldName'],
              dimension: row['dimension'],
              x: int.parse(row['x'].toString()),
              y: int.parse(row['y'].toString()),
              z: int.parse(row['z'].toString()),
            ))
        .toList();
    return items;
  }

  // Filters cords from the online database based on the provided parameters.
  Future<List<Cord>> _filterByOnline(String cordName, String worldName,
      String keywords, String dimension, int x, int y, int z) async {
    if (onlineDB == null) return [];
    final keyWords = _generateFilterKeywords(
      cordName.isEmpty ? null : cordName.trim(),
      worldName.isEmpty ? null : worldName.trim(),
      keywords.isEmpty ? null : keywords,
      dimension.isEmpty ? null : dimension,
      x == -1 ? null : x,
      y == -1 ? null : y,
      z == -1 ? null : z,
    );
    final filterCommand =
        "SELECT * FROM cords ${keyWords.isNotEmpty ? "WHERE ${keyWords.join(" AND ")}" : ''}";
    final result = await onlineDB!.query(filterCommand);
    if (result.isEmpty) return [];
    final items = result
        .map((row) => Cord(
              id: row['id'] as int,
              name: row['cordName'] as String,
              keywords: row['keywords'] as String,
              worldName: row['worldName'] as String,
              dimension: row['dimension'] as String,
              x: row['x'] as int,
              y: row['y'] as int,
              z: row['z'] as int,
            ))
        .toList();
    return items;
  }

  /// Filters cords from the database based on the selected database type and provided parameters.
  Future<List<Cord>> filterCords(String cordName, String worldName,
      String keywords, String dimension, int x, int y, int z) {
    if (dbType == DataBaseType.local) {
      return _filterByLocal(cordName, worldName, keywords, dimension, x, y, z);
    } else {
      return _filterByOnline(cordName, worldName, keywords, dimension, x, y, z);
    }
  }
}
