import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../navigation/app_router.dart';
import '../utils/responsive_helper.dart';
import '../widgets/responsive_builder.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

/// HomeScreen displays the dashboard with task overview and quick actions.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TaskProvider _taskProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_taskProvider.isLoading) {
      _taskProvider = Provider.of<TaskProvider>(context, listen: false);
      _taskProvider.refreshAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    _taskProvider = context.watch<TaskProvider>();
    
    if (_taskProvider.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_taskProvider.error!)),
        );
      });
    }
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        showSearchBar: true,
        onNotificationTap: () {
          // TODO: Implement notifications
        },
      ),
      body: ResponsiveBuilder(
        mobile: SingleChildScrollView(
          padding: ResponsiveHelper.responsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskOverview(context),
              const SizedBox(height: 24),
              _buildUpcomingTasks(context),
              const SizedBox(height: 24),
              _buildQuickActions(context),
            ],
          ),
        ),
        tablet: SingleChildScrollView(
          padding: ResponsiveHelper.responsivePadding(context),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTaskOverview(context),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: _buildQuickActions(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildUpcomingTasks(context),
            ],
          ),
        ),
        desktop: SingleChildScrollView(
          padding: ResponsiveHelper.responsivePadding(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildTaskOverview(context),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: _buildUpcomingTasks(context),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTaskOverview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ResponsiveBuilder(
              mobile: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                _buildStatCard(
                  context,
                  'Pending',
                  _taskProvider.tasks.where((t) => !t.isCompleted).length.toString(),
                  Icons.pending_actions,
                  Colors.orange,
                ),
                _buildStatCard(
                  context,
                  'Completed',
                  _taskProvider.tasks.where((t) => t.isCompleted).length.toString(),
                  Icons.task_alt,
                  Colors.green,
                ),
                _buildStatCard(
                  context,
                  'Overdue',
                  _taskProvider.overdueTasksCount.toString(),
                  Icons.warning_amber,
                  Colors.red,
                ),
                ],
              ),
              tablet: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    context,
                    'Pending',
                    '5',
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    'Completed',
                    '12',
                    Icons.task_alt,
                    Colors.green,
                  ),
                  _buildStatCard(
                    context,
                    'Overdue',
                    '2',
                    Icons.warning_amber,
                    Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          count,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildUpcomingTasks(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to tasks screen
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_taskProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_taskProvider.tasks.isEmpty)
              const Center(child: Text('No upcoming tasks'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _taskProvider.tasks.take(3).length,
                itemBuilder: (context, index) {
                  final task = _taskProvider.tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () => AppRouter.navigateToTaskDetail(
                      context,
                      task.id.toString(),
                    ),
                    onComplete: (completed) {
                      if (completed) {
                        _taskProvider.markTaskAsComplete(task.id);
                      }
                    },
                    onDelete: () => _taskProvider.deleteTask(task.id),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  context,
                  'New Task',
                  Icons.add_task,
                  () => AppRouter.navigateToCreateTask(context),
                ),
                _buildActionButton(
                  context,
                  'Calendar',
                  Icons.calendar_today,
                  () => AppRouter.navigateToCalendar(context),
                ),
                _buildActionButton(
                  context,
                  'Analytics',
                  Icons.analytics,
                  () => AppRouter.navigateToAnalytics(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
