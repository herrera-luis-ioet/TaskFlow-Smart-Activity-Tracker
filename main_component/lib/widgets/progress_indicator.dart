import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// A custom circular progress indicator widget.
///
/// This widget displays progress in a circular format with an optional label
/// and customizable colors.
class TaskCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final double size;
  final Color? color;
  final String? label;
  final bool showPercentage;

  const TaskCircularProgressIndicator({
    super.key,
    required this.progress,
    this.size = 48.0,
    this.color,
    this.label,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? theme.colorScheme.primary;
    final percentage = (progress * 100).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                backgroundColor: Color.fromRGBO(
                  progressColor.r.toInt(),
                  progressColor.g.toInt(),
                  progressColor.b.toInt(),
                  0.2,
                ),
                color: progressColor,
                strokeWidth: size * 0.1,
              ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: AppTextStyles.bodySmall().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        if (label != null) ...[  
          const SizedBox(height: 8),
          Text(
            label!,
            style: AppTextStyles.caption(),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// A custom linear progress indicator widget.
///
/// This widget displays progress in a linear format with optional label
/// and customizable colors.
class TaskLinearProgressIndicator extends StatelessWidget {
  final double progress;
  final Color? color;
  final String? label;
  final bool showPercentage;
  final double height;

  const TaskLinearProgressIndicator({
    super.key,
    required this.progress,
    this.color,
    this.label,
    this.showPercentage = true,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? theme.colorScheme.primary;
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: AppTextStyles.caption(),
                  ),
                if (showPercentage)
                  Text(
                    '$percentage%',
                    style: AppTextStyles.caption().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Color.fromRGBO(
              progressColor.r.toInt(),
              progressColor.g.toInt(),
              progressColor.b.toInt(),
              0.2,
            ),
            color: progressColor,
            minHeight: height,
          ),
        ),
      ],
    );
  }
}
