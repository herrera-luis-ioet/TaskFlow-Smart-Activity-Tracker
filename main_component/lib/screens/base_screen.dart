import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../navigation/app_router.dart';

/// BaseScreen serves as the container for main screens with bottom navigation.
///
/// This screen manages the bottom navigation bar and handles switching between
/// the main screens of the application.
class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  void _onNavigationItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppRouter.getScreenForIndex(_currentIndex),
      bottomNavigationBar: BottomNavBar.standard(
        currentIndex: _currentIndex,
        onTap: _onNavigationItemTapped,
      ),
    );
  }
}
