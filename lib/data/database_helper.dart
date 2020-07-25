import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableTask = "taskTable";
  final String columnId = "id";
  final String columnTitle = "title";
  final String columnStartTime = "startTime";
  final String columnEndTime = "endTime";
  final String columnDate = "date";
  final String columnCategory = "category";
  final String columnToggle = "toggle";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentDirectory.path, "maindb.db"); //home://directory/files/maindb.db

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  /*
     id | title | startTime | endTime | date | category |toggle
     ------------------------
     1  | Lecture    | 2019282321 | 1808244810 | 182327123 | "Classes" | 110

   */

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableTask($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnStartTime INTEGER, $columnEndTime INTEGER,$columnDate INTEGER,$columnCategory TEXT,$columnToggle TEXT)");
  }

  //CRUD - CREATE, READ, UPDATE , DELETE

  //Insertion
  Future<int> saveTask(Task task) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableTask", task.toMap());
    return res;
  }

  //Get Songs
  Future<List> getAllTasks() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableTask");

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableTask"));
  }

  Future<Task> getTask(int id) async {
    var dbClient = await db;

    var result = await dbClient
        .rawQuery("SELECT * FROM $tableTask WHERE $columnId = $id");
    if (result.length == 0) return null;
    return new Task.fromMap(result.first);
  }

  Future<int> deleteTask(String title) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableTask, where: "$columnTitle = ?", whereArgs: [title]);
  }

  Future<int> updateTask(Task task) async {
    var dbClient = await db;
    return await dbClient.update(tableTask, task.toMap(),
        where: "$columnId = ?", whereArgs: [task.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
