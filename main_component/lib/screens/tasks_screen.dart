import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/responsive_helper.dart';
import '../widgets/responsive_builder.dart';

/// TasksScreen displays a list of tasks with filtering and sorting options.
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        onPressed: () {
          // TODO: Navigate to create task
        },
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
    return Card(
      margin: ResponsiveHelper.responsivePadding(context),
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('All Tasks'),
            leading: const Icon(Icons.list),
            selected: true,
            onTap: () {},
          ),
          ListTile(
            title: const Text('Today'),
            leading: const Icon(Icons.today),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Upcoming'),
            leading: const Icon(Icons.upcoming),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Completed'),
            leading: const Icon(Icons.task_alt),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return ListView.builder(
      padding: ResponsiveHelper.responsivePadding(context),
      itemCount: 10, // TODO: Replace with actual task count
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Task ${index + 1}'),
            subtitle: Text('Due in ${index + 1} days'),
            leading: const Icon(Icons.task),
            trailing: const Icon(Icons.more_vert),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildTaskGrid(BuildContext context) {
    return GridView.builder(
      padding: ResponsiveHelper.responsivePadding(context),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 10, // TODO: Replace with actual task count
      itemBuilder: (context, index) {
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
                      'Task ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Due in ${index + 1} days',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                LinearProgressIndicator(
                  value: (index + 1) / 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
