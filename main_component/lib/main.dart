import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' show Database, openDatabase, getDatabasesPath;
import 'package:path/path.dart' show join;
import 'theme/app_theme.dart';
import 'navigation/app_router.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'taskflow.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT,
            priority INTEGER,
            isCompleted INTEGER DEFAULT 0,
            createdAt TEXT DEFAULT CURRENT_TIMESTAMP
          )
          ''',
        );
      },
    );
  }
}

class TaskProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  Future<void> loadTasks() async {
    try {
      final db = await _databaseHelper.database;
      _tasks = await db.query('tasks', orderBy: 'createdAt DESC');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      // Handle error appropriately
    }
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert('tasks', task);
      task['id'] = id;
      _tasks.insert(0, task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
      // Handle error appropriately
    }
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        'tasks',
        task,
        where: 'id = ?',
        whereArgs: [task['id']],
      );
      final index = _tasks.indexWhere((t) => t['id'] == task['id']);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
      // Handle error appropriately
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      _tasks.removeWhere((task) => task['id'] == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
      // Handle error appropriately
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  try {
    await DatabaseHelper().database;
  } catch (e) {
    debugPrint('Error initializing database: $e');
    // Handle database initialization error
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'TaskFlow Smart Activity Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow Smart Activity Tracker'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to TaskFlow',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Smart Activity Tracker',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            const Text(
              'App is being set up...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
