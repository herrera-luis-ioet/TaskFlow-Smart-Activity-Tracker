import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

/// Enum representing task sort criteria
enum TaskSortCriteria {
  dueDate,
  priority,
  title,
  createdAt,
}

/// Provider class that manages task state across the application
class TaskProvider extends ChangeNotifier {
  final TaskService _taskService;

  // State variables
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _error;
  
  // Filter state
  String? _categoryFilter;
  TaskPriority? _priorityFilter;
  DateTime? _startDateFilter;
  DateTime? _endDateFilter;
  bool? _completedFilter;
  
  // Sort state
  TaskSortCriteria _sortCriteria = TaskSortCriteria.dueDate;
  bool _sortAscending = true;

  // Analytics state
  double _productivityScore = 0.0;
  Map<String, dynamic> _completionTrends = {};
  Map<String, double> _categoryStats = {};
  Map<TaskPriority, double> _priorityStats = {};
  int _overdueTasksCount = 0;

  TaskProvider({required TaskService taskService}) : _taskService = taskService;

  // Getters
  List<TaskModel> get tasks => _getFilteredAndSortedTasks();
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get productivityScore => _productivityScore;
  Map<String, dynamic> get completionTrends => _completionTrends;
  Map<String, double> get categoryStats => _categoryStats;
  Map<TaskPriority, double> get priorityStats => _priorityStats;
  int get overdueTasksCount => _overdueTasksCount;

  // Filter getters
  String? get categoryFilter => _categoryFilter;
  TaskPriority? get priorityFilter => _priorityFilter;
  DateTime? get startDateFilter => _startDateFilter;
  DateTime? get endDateFilter => _endDateFilter;
  bool? get completedFilter => _completedFilter;

  // Sort getters
  TaskSortCriteria get sortCriteria => _sortCriteria;
  bool get sortAscending => _sortAscending;

  /// Loads all tasks and updates the state
  Future<void> loadTasks() async {
    _setLoading(true);
    try {
      _tasks = await _taskService.getTasks(
        category: _categoryFilter,
        priority: _priorityFilter,
        startDate: _startDateFilter,
        endDate: _endDateFilter,
        completed: _completedFilter,
      );
      _error = null;
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Creates a new task
  Future<void> createTask(TaskModel task) async {
    _setLoading(true);
    try {
      await _taskService.createTask(task);
      await loadTasks();
      _error = null;
    } catch (e) {
      _error = 'Failed to create task: $e';
      _setLoading(false);
    }
  }

  /// Updates an existing task
  Future<void> updateTask(TaskModel task) async {
    _setLoading(true);
    try {
      await _taskService.updateTask(task);
      await loadTasks();
      _error = null;
    } catch (e) {
      _error = 'Failed to update task: $e';
      _setLoading(false);
    }
  }

  /// Deletes a task by ID
  Future<void> deleteTask(int id) async {
    _setLoading(true);
    try {
      await _taskService.deleteTask(id);
      await loadTasks();
      _error = null;
    } catch (e) {
      _error = 'Failed to delete task: $e';
      _setLoading(false);
    }
  }

  /// Marks a task as complete
  Future<void> markTaskAsComplete(int id) async {
    _setLoading(true);
    try {
      await _taskService.markTaskAsComplete(id);
      await loadTasks();
      _error = null;
    } catch (e) {
      _error = 'Failed to mark task as complete: $e';
      _setLoading(false);
    }
  }

  /// Updates filter settings
  void setFilters({
    String? category,
    TaskPriority? priority,
    DateTime? startDate,
    DateTime? endDate,
    bool? completed,
  }) {
    _categoryFilter = category;
    _priorityFilter = priority;
    _startDateFilter = startDate;
    _endDateFilter = endDate;
    _completedFilter = completed;
    notifyListeners();
  }

  /// Clears all filters
  void clearFilters() {
    _categoryFilter = null;
    _priorityFilter = null;
    _startDateFilter = null;
    _endDateFilter = null;
    _completedFilter = null;
    notifyListeners();
  }

  /// Updates sort settings
  void setSortCriteria(TaskSortCriteria criteria, {bool? ascending}) {
    _sortCriteria = criteria;
    if (ascending != null) _sortAscending = ascending;
    notifyListeners();
  }

  /// Updates loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Returns filtered and sorted tasks based on current settings
  List<TaskModel> _getFilteredAndSortedTasks() {
    List<TaskModel> filteredTasks = List.from(_tasks);

    // Apply sorting
    filteredTasks.sort((a, b) {
      int comparison;
      switch (_sortCriteria) {
        case TaskSortCriteria.dueDate:
          comparison = a.dueDate.compareTo(b.dueDate);
          break;
        case TaskSortCriteria.priority:
          comparison = a.priority.index.compareTo(b.priority.index);
          break;
        case TaskSortCriteria.title:
          comparison = a.title.compareTo(b.title);
          break;
        case TaskSortCriteria.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filteredTasks;
  }

  /// Loads and updates analytics data
  Future<void> loadAnalytics() async {
    _setLoading(true);
    try {
      _productivityScore = await _taskService.calculateProductivityScore();
      _completionTrends = await _taskService.getCompletionTrends();
      _categoryStats = await _taskService.getCategoryStats();
      _priorityStats = await _taskService.getPriorityStats();
      _overdueTasksCount = await _taskService.getOverdueTasks();
      _error = null;
    } catch (e) {
      _error = 'Failed to load analytics: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Refreshes both tasks and analytics data
  Future<void> refreshAll() async {
    await Future.wait([
      loadTasks(),
      loadAnalytics(),
    ]);
  }
}
