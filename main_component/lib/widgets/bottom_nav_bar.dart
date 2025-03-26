import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Represents a navigation item in the bottom navigation bar.
class NavItem {
  final String label;
  final IconData icon;
  final int badgeCount;

  const NavItem({
    required this.label,
    required this.icon,
    this.badgeCount = 0,
  });
}

/// A custom bottom navigation bar for the TaskFlow application.
///
/// This widget provides navigation between main app sections and supports
/// notification badges for each section.
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItem> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  /// Creates a default BottomNavBar with standard navigation items.
  factory BottomNavBar.standard({
    required int currentIndex,
    required Function(int) onTap,
    Map<int, int> badges = const {},
  }) {
    return BottomNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        NavItem(
          label: 'Home',
          icon: Icons.home_outlined,
          badgeCount: badges[0] ?? 0,
        ),
        NavItem(
          label: 'Tasks',
          icon: Icons.task_outlined,
          badgeCount: badges[1] ?? 0,
        ),
        NavItem(
          label: 'Calendar',
          icon: Icons.calendar_today_outlined,
          badgeCount: badges[2] ?? 0,
        ),
        NavItem(
          label: 'Analytics',
          icon: Icons.analytics_outlined,
          badgeCount: badges[3] ?? 0,
        ),
        NavItem(
          label: 'Profile',
          icon: Icons.person_outline,
          badgeCount: badges[4] ?? 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: items.map((item) => NavigationDestination(
        icon: Stack(
          children: [
            Icon(item.icon),
            if (item.badgeCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    item.badgeCount > 99 ? '99+' : item.badgeCount.toString(),
                    style: AppTextStyles.overline().copyWith(
                      color: theme.colorScheme.onError,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        label: item.label,
      )).toList(),
    );
  }
}
