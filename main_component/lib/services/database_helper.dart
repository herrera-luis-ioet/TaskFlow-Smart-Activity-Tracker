import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

/// DatabaseHelper class provides methods to interact with the SQLite database
/// for the TaskFlow application. It implements the Singleton pattern to ensure
/// only one instance of the database connection exists.
class DatabaseHelper {
  static const String _databaseName = 'taskflow.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tableTask = 'tasks';

  // Singleton instance
  static DatabaseHelper? _instance;
  static Database? _database;

  // Private constructor
  DatabaseHelper._();

  /// Gets the singleton instance of DatabaseHelper
  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  /// Gets the database instance, creating it if necessary
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initializes the database, creating it if it doesn't exist
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Creates the database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTask (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT NOT NULL,
        priority TEXT NOT NULL,
        category TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        sub_tasks TEXT,
        attachments TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');
  }

  /// Handles database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future schema upgrades here
  }

  /// Inserts a new task into the database
  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      tableTask,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves a task by its ID
  Future<TaskModel?> getTask(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTask,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  /// Retrieves all tasks from the database
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableTask);

    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  /// Updates an existing task
  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db.update(
      tableTask,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Deletes a task by its ID
  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      tableTask,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Marks a task as complete
  Future<void> markTaskAsComplete(String id) async {
    final db = await database;
    await db.update(
      tableTask,
      {
        'is_completed': 1,
        'completed_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Retrieves tasks by category
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTask,
      where: 'category = ?',
      whereArgs: [category],
    );

    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  /// Retrieves tasks by priority
  Future<List<TaskModel>> getTasksByPriority(TaskPriority priority) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTask,
      where: 'priority = ?',
      whereArgs: [priority.toString().split('.').last],
    );

    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  /// Retrieves tasks within a date range
  Future<List<TaskModel>> getTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTask,
      where: 'due_date BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  /// Retrieves completed tasks
  Future<List<TaskModel>> getCompletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTask,
      where: 'is_completed = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  /// Gets task statistics
  Future<Map<String, dynamic>> getTasksStats() async {
    final db = await database;
    final totalTasks = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM $tableTask',
    ));
    final completedTasks = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM $tableTask WHERE is_completed = 1',
    ));
    final dueTasks = Sqflite.firstIntValue(await db.rawQuery(
      "SELECT COUNT(*) FROM $tableTask WHERE due_date <= date('now') AND is_completed = 0",
    ));

    return {
      'totalTasks': totalTasks ?? 0,
      'completedTasks': completedTasks ?? 0,
      'dueTasks': dueTasks ?? 0,
      'completionRate': totalTasks != null && totalTasks > 0
          ? (completedTasks ?? 0) / totalTasks
          : 0.0,
    };
  }

  /// Closes the database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
