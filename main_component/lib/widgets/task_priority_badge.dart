import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A widget that displays a task's priority level with appropriate colors and icons.
///
/// This widget adapts to both light and dark themes and provides visual feedback
/// about the priority level of a task.
class TaskPriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool compact;

  const TaskPriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  Color _getPriorityColor() {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.highPriority;
      case TaskPriority.medium:
        return AppColors.mediumPriority;
      case TaskPriority.low:
        return AppColors.lowPriority;
    }
  }

  IconData _getPriorityIcon() {
    switch (priority) {
      case TaskPriority.high:
        return Icons.priority_high;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.low:
        return Icons.arrow_downward;
    }
  }

  String _getPriorityText() {
    return priority.toString().split('.').last.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor();
    final icon = _getPriorityIcon();
    final text = _getPriorityText();

    if (compact) {
      return Icon(
        icon,
        color: color,
        size: 16,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          color.r.toInt(),
          color.g.toInt(),
          color.b.toInt(),
          0.1,
        ),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.bodySmall().copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
