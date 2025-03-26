import '../models/task_model.dart';
import '../services/database_helper.dart';

/// TaskRepository provides a clean interface for task-related database operations.
/// It uses DatabaseHelper to perform the actual database operations and provides
/// additional methods for querying and analyzing tasks.
class TaskRepository {
  final DatabaseHelper _databaseHelper;

  /// Creates a new instance of TaskRepository with the provided DatabaseHelper.
  /// If no DatabaseHelper is provided, it uses the singleton instance.
  TaskRepository([DatabaseHelper? databaseHelper])
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  // CRUD Operations

  /// Creates a new task in the database.
  ///
  /// Returns a Future that completes when the task is created.
  /// PUBLIC_INTERFACE
  Future<void> createTask(TaskModel task) async {
    await _databaseHelper.insertTask(task);
  }

  /// Retrieves a task by its ID.
  ///
  /// Returns a Future that completes with the TaskModel if found,
  /// or null if no task exists with the given ID.
  /// PUBLIC_INTERFACE
  Future<TaskModel?> getTaskById(String id) async {
    return await _databaseHelper.getTask(id);
  }

  /// Retrieves all tasks from the database.
  ///
  /// Returns a Future that completes with a list of all TaskModel instances.
  /// PUBLIC_INTERFACE
  Future<List<TaskModel>> getAllTasks() async {
    return await _databaseHelper.getAllTasks();
  }

  /// Updates an existing task in the database.
  ///
  /// Returns a Future that completes when the task is updated.
  /// PUBLIC_INTERFACE
  Future<void> updateTask(TaskModel task) async {
    await _databaseHelper.updateTask(task);
  }

  /// Deletes a task by its ID.
  ///
  /// Returns a Future that completes when the task is deleted.
  /// PUBLIC_INTERFACE
  Future<void> deleteTask(String id) async {
    await _databaseHelper.deleteTask(id);
  }

  // Task Status Operations

  /// Marks a task as complete and sets the completion date.
  ///
  /// Returns a Future that completes when the task is marked as complete.
  /// PUBLIC_INTERFACE
  Future<void> markTaskAsComplete(String id) async {
    await _databaseHelper.markTaskAsComplete(id);
  }

  // Query Operations

  /// Retrieves all tasks in a specific category.
  ///
  /// Returns a Future that completes with a list of TaskModel instances
  /// in the specified category.
  /// PUBLIC_INTERFACE
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    return await _databaseHelper.getTasksByCategory(category);
  }

  /// Retrieves all tasks with a specific priority.
  ///
  /// Returns a Future that completes with a list of TaskModel instances
  /// with the specified priority.
  /// PUBLIC_INTERFACE
  Future<List<TaskModel>> getTasksByPriority(TaskPriority priority) async {
    return await _databaseHelper.getTasksByPriority(priority);
  }

  /// Retrieves all tasks due within a specific date range.
  ///
  /// Returns a Future that completes with a list of TaskModel instances
  /// due between the specified start and end dates.
  /// PUBLIC_INTERFACE
  Future<List<TaskModel>> getTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _databaseHelper.getTasksByDateRange(startDate, endDate);
  }

  /// Retrieves all completed tasks.
  ///
  /// Returns a Future that completes with a list of completed TaskModel instances.
  /// PUBLIC_INTERFACE
  Future<List<TaskModel>> getCompletedTasks() async {
    return await _databaseHelper.getCompletedTasks();
  }

  /// Retrieves all overdue tasks that are not completed.
  ///
  /// Returns a Future that completes with a list of overdue TaskModel instances.
  /// PUBLIC_INTERFACE
  Future<List<TaskModel>> getOverdueTasks() async {
    final now = DateTime.now();
    final tasks = await _databaseHelper.getTasksByDateRange(
      DateTime(2000), // A date far in the past
      now,
    );
    return tasks.where((task) => !task.isCompleted).toList();
  }

  // Analytics Operations

  /// Retrieves task statistics including total tasks, completed tasks,
  /// due tasks, and completion rate.
  ///
  /// Returns a Future that completes with a map containing the statistics.
  /// PUBLIC_INTERFACE
  Future<Map<String, dynamic>> getTaskStatistics() async {
    return await _databaseHelper.getTasksStats();
  }

  /// Calculates the completion rate for tasks in a specific category.
  ///
  /// Returns a Future that completes with the completion rate as a double
  /// between 0 and 1.
  /// PUBLIC_INTERFACE
  Future<double> getCategoryCompletionRate(String category) async {
    final tasks = await getTasksByCategory(category);
    if (tasks.isEmpty) return 0.0;

    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }

  /// Calculates the completion rate for tasks with a specific priority.
  ///
  /// Returns a Future that completes with the completion rate as a double
  /// between 0 and 1.
  /// PUBLIC_INTERFACE
  Future<double> getPriorityCompletionRate(TaskPriority priority) async {
    final tasks = await getTasksByPriority(priority);
    if (tasks.isEmpty) return 0.0;

    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }

  /// Calculates task completion trends over time.
  ///
  /// Returns a Future that completes with a map containing completion counts
  /// for each day in the specified range.
  /// PUBLIC_INTERFACE
  Future<Map<DateTime, int>> getCompletionTrend(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final completedTasks = await _databaseHelper.getCompletedTasks();
    final trend = <DateTime, int>{};

    // Initialize all dates in range with 0
    for (var date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      trend[DateTime(date.year, date.month, date.day)] = 0;
    }

    // Count completed tasks for each day
    for (final task in completedTasks) {
      if (task.completedAt != null &&
          task.completedAt!.isAfter(startDate) &&
          task.completedAt!.isBefore(endDate.add(const Duration(days: 1)))) {
        final completionDate = DateTime(
          task.completedAt!.year,
          task.completedAt!.month,
          task.completedAt!.day,
        );
        trend[completionDate] = (trend[completionDate] ?? 0) + 1;
      }
    }

    return trend;
  }
}
