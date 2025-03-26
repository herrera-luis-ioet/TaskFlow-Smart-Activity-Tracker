import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/responsive_helper.dart';
import '../widgets/responsive_builder.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../navigation/app_router.dart';

/// TasksScreen displays a list of tasks with filtering and sorting options.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late TaskProvider _taskProvider;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _taskProvider = context.read<TaskProvider>();
      _taskProvider.loadTasks();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    if (taskProvider.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(taskProvider.error!)),
        );
      });
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tasks',
        showSearchBar: true,
        onNotificationTap: () {
          // TODO: Implement notifications
        },
      ),
      body: ResponsiveBuilder(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppRouter.navigateToCreateTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildFilters(context),
        Expanded(
          child: _buildTaskList(context),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: ResponsiveHelper.screenWidth(context) * 0.3,
          child: _buildFilters(context),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _buildTaskList(context),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: ResponsiveHelper.screenWidth(context) * 0.2,
          child: _buildFilters(context),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _buildTaskGrid(context),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return Card(
      margin: ResponsiveHelper.responsivePadding(context),
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('All Tasks'),
            leading: const Icon(Icons.list),
            selected: taskProvider.completedFilter == null,
            onTap: () => taskProvider.setFilters(completed: null),
          ),
          ListTile(
            title: const Text('Today'),
            leading: const Icon(Icons.today),
            selected: taskProvider.startDateFilter == today && taskProvider.endDateFilter == today,
            onTap: () => taskProvider.setFilters(
              startDate: today,
              endDate: today,
            ),
          ),
          ListTile(
            title: const Text('Upcoming'),
            leading: const Icon(Icons.upcoming),
            selected: taskProvider.startDateFilter == tomorrow,
            onTap: () => taskProvider.setFilters(
              startDate: tomorrow,
              endDate: null,
            ),
          ),
          ListTile(
            title: const Text('Completed'),
            leading: const Icon(Icons.task_alt),
            selected: taskProvider.completedFilter == true,
            onTap: () => taskProvider.setFilters(completed: true),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    if (taskProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskProvider.tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No tasks found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: ResponsiveHelper.responsivePadding(context),
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.tasks[index];
        return TaskCard(
          task: task,
          onTap: () => AppRouter.navigateToTaskDetail(context, task.id.toString()),
          onComplete: (completed) {
            if (completed) {
              taskProvider.markTaskAsComplete(task.id);
            }
          },
          onDelete: () => taskProvider.deleteTask(task.id),
        );
      },
    );
  }

  Widget _buildTaskGrid(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    if (taskProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskProvider.tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No tasks found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: ResponsiveHelper.responsivePadding(context),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.tasks[index];
        return TaskCard(
          task: task,
          onTap: () => AppRouter.navigateToTaskDetail(context, task.id.toString()),
          onComplete: (completed) {
            if (completed) {
              taskProvider.markTaskAsComplete(task.id);
            }
          },
          onDelete: () => taskProvider.deleteTask(task.id),
        );
      },
    );
  }
}
