import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// A widget that displays a message when a list or section is empty.
///
/// This widget supports customizable illustrations, messages, and actions to guide
/// users when there is no content to display.
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? illustration;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.illustration,
    this.onAction,
    this.actionLabel,
  });

  /// Creates an EmptyState for an empty task list.
  factory EmptyState.noTasks({
    VoidCallback? onAddTask,
  }) {
    return EmptyState(
      title: 'No Tasks Yet',
      message: 'Start adding tasks to organize your work and track your progress.',
      icon: Icons.task_outlined,
      onAction: onAddTask,
      actionLabel: 'Add Task',
    );
  }

  /// Creates an EmptyState for an empty search result.
  factory EmptyState.noSearchResults({
    String searchTerm = '',
  }) {
    return EmptyState(
      title: 'No Results Found',
      message: searchTerm.isNotEmpty
          ? 'No items match "$searchTerm". Try a different search term.'
          : 'Try searching with different keywords.',
      icon: Icons.search_outlined,
    );
  }

  /// Creates an EmptyState for no notifications.
  factory EmptyState.noNotifications() {
    return const EmptyState(
      title: 'No Notifications',
      message: 'You\'re all caught up! Check back later for updates.',
      icon: Icons.notifications_none_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (illustration != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: illustration!,
              )
            else
              Icon(
                icon,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.h5(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium().copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[  
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
