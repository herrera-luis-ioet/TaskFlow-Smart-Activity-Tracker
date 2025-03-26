import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// A customizable chip widget for displaying task categories.
///
/// This widget follows the app's theme system and supports custom colors
/// for different categories.
class CategoryChip extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final bool selected;

  const CategoryChip({
    super.key,
    required this.label,
    this.color,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? Color.fromRGBO(
                    chipColor.r.toInt(),
                    chipColor.g.toInt(),
                    chipColor.b.toInt(),
                    0.2,
                  )
                : Color.fromRGBO(
                    chipColor.r.toInt(),
                    chipColor.g.toInt(),
                    chipColor.b.toInt(),
                    0.1,
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? chipColor
                  : Color.fromRGBO(
                      chipColor.r.toInt(),
                      chipColor.g.toInt(),
                      chipColor.b.toInt(),
                      0.3,
                    ),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[  
                Icon(
                  Icons.check,
                  size: 16,
                  color: chipColor,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: AppTextStyles.bodySmall().copyWith(
                  color: selected
                      ? chipColor
                      : theme.textTheme.bodySmall?.color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
