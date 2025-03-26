import '../models/task_model.dart';
import '../repositories/task_repository.dart';

/// Exception thrown when task validation fails
class TaskValidationException implements Exception {
  final String message;
  TaskValidationException(this.message);
  @override
  String toString() => message;
}

/// Service class that implements business logic for task operations
class TaskService {
  final TaskRepository _repository;

  TaskService({required TaskRepository repository}) : _repository = repository;

  // VALIDATION METHODS

  /// Validates task data before creation or update
  void _validateTask(TaskModel task) {
    if (task.title.isEmpty) {
      throw TaskValidationException('Task title cannot be empty');
    }
    if (task.dueDate.isBefore(DateTime.now())) {
      throw TaskValidationException('Due date cannot be in the past');
    }
    if (task.subTasks.any((subtask) => subtask.title.isEmpty)) {
      throw TaskValidationException('Subtask title cannot be empty');
    }
  }

  // CORE TASK OPERATIONS

  /// Creates a new task with validation
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      _validateTask(task);
      await _repository.createTask(task);
      return await _repository.getTaskById(task.id) ?? task;
    } catch (e) {
      if (e is TaskValidationException) rethrow;
      throw Exception('Failed to create task: $e');
    }
  }

  /// Updates an existing task with validation
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      _validateTask(task);
      await _repository.updateTask(task);
      return await _repository.getTaskById(task.id) ?? task;
    } catch (e) {
      if (e is TaskValidationException) rethrow;
      throw Exception('Failed to update task: $e');
    }
  }

  /// Retrieves a task by its ID
  Future<TaskModel?> getTaskById(int id) async {
    try {
      return await _repository.getTaskById(id.toString());
    } catch (e) {
      throw Exception('Failed to retrieve task: $e');
    }
  }

  /// Deletes a task by its ID
  Future<void> deleteTask(int id) async {
    try {
      await _repository.deleteTask(id.toString());
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// Marks a task as complete
  Future<void> markTaskAsComplete(int id) async {
    try {
      await _repository.markTaskAsComplete(id.toString());
    } catch (e) {
      throw Exception('Failed to mark task as complete: $e');
    }
  }

  // TASK QUERYING AND FILTERING

  /// Retrieves all tasks with optional filtering
  Future<List<TaskModel>> getTasks({
    String? category,
    TaskPriority? priority,
    DateTime? startDate,
    DateTime? endDate,
    bool? completed,
  }) async {
    try {
      if (category?.isNotEmpty ?? false) {
        return await _repository.getTasksByCategory(category!);
      }
      if (priority != null) {
        return await _repository.getTasksByPriority(priority);
      }
      if (startDate != null && endDate != null) {
        return await _repository.getTasksByDateRange(startDate, endDate);
      }
      if (completed == true) {
        return await _repository.getCompletedTasks();
      }
      return await _repository.getAllTasks();
    } catch (e) {
      throw Exception('Failed to retrieve tasks: $e');
    }
  }

  // ANALYTICS AND STATISTICS

  /// Calculates productivity score based on task completion and priorities
  Future<double> calculateProductivityScore() async {
    try {
      final stats = await _repository.getTaskStatistics();
      if (stats['total'] == 0) return 0.0;
      
      // Calculate base score from completion rate
      double score = (stats['completed'] / stats['total']) * 100;
      
      // Adjust score based on priority completion rates
      final highPriorityRate = await _repository.getPriorityCompletionRate(TaskPriority.high);
      score += (highPriorityRate * 0.3); // 30% weight for high priority tasks
      
      return double.parse(score.toStringAsFixed(2));
    } catch (e) {
      throw Exception('Failed to calculate productivity score: $e');
    }
  }

  /// Gets task completion trends over time
  Future<Map<String, dynamic>> getCompletionTrends() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 30));
      final trend = await _repository.getCompletionTrend(startDate, now);
      return trend.map((key, value) => MapEntry(key.toIso8601String(), value));
    } catch (e) {
      throw Exception('Failed to get completion trends: $e');
    }
  }

  /// Gets category-wise task completion statistics
  Future<Map<String, double>> getCategoryStats() async {
    try {
      final tasks = await _repository.getAllTasks();
      final categories = tasks.map((t) => t.category).where((c) => c.trim().isNotEmpty).toSet();
      
      Map<String, double> stats = {};
      for (final category in categories) {
        stats[category] = await _repository.getCategoryCompletionRate(category);
      }
      return stats;
    } catch (e) {
      throw Exception('Failed to get category statistics: $e');
    }
  }

  /// Gets priority-wise task completion statistics
  Future<Map<TaskPriority, double>> getPriorityStats() async {
    try {
      Map<TaskPriority, double> stats = {};
      for (final priority in TaskPriority.values) {
        stats[priority] = await _repository.getPriorityCompletionRate(priority);
      }
      return stats;
    } catch (e) {
      throw Exception('Failed to get priority statistics: $e');
    }
  }

  /// Gets overdue tasks count
  Future<int> getOverdueTasks() async {
    try {
      final tasks = await _repository.getAllTasks();
      return tasks.where((task) =>
        !task.isCompleted &&
        task.dueDate.isBefore(DateTime.now())
      ).length;
    } catch (e) {
      throw Exception('Failed to get overdue tasks count: $e');
    }
  }
}
