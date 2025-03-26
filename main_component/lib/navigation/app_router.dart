import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/tasks_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/task_detail_screen.dart';
import '../screens/create_task_screen.dart';
import '../screens/base_screen.dart';

/// AppRouter handles the navigation for the TaskFlow application.
///
/// This class provides methods for navigating between different screens
/// and managing the navigation stack using named routes.
class AppRouter {
  // Route names
  static const String home = '/';
  static const String tasks = '/tasks';
  static const String calendar = '/calendar';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String taskDetail = '/task-detail';
  static const String createTask = '/create-task';

  /// Generate routes for the application.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const BaseScreen());
      case taskDetail:
        final taskId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TaskDetailScreen(taskId: taskId),
        );
      case createTask:
        final taskId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => CreateTaskScreen(taskId: taskId),
        );
      default:
        return MaterialPageRoute(builder: (_) => const BaseScreen());
    }
  }

  /// Get the widget for a main screen based on index.
  static Widget getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const TasksScreen();
      case 2:
        return const CalendarScreen();
      case 3:
        return const AnalyticsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  /// Navigate to a task detail screen.
  static void navigateToTaskDetail(BuildContext context, String taskId) {
    Navigator.pushNamed(
      context,
      taskDetail,
      arguments: taskId,
    );
  }

  /// Navigate to create/edit task screen.
  static void navigateToCreateTask(BuildContext context, [String? taskId]) {
    Navigator.pushNamed(
      context,
      createTask,
      arguments: taskId,
    );
  }

  /// Pop the current screen.
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
