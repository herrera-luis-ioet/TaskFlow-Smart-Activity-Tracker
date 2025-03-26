import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/responsive_helper.dart';

/// AnalyticsScreen displays productivity analytics and reports.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Analytics',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveHelper.responsiveValue(
          context,
          mobile: 16.0,
          tablet: 24.0,
          desktop: 32.0,
        )),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!ResponsiveHelper.isDesktop(context))
                _buildProductivityScore(context),
              if (!ResponsiveHelper.isDesktop(context))
                SizedBox(height: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 24.0,
                  tablet: 32.0,
                  desktop: 40.0,
                )),
              if (!ResponsiveHelper.isDesktop(context))
                _buildTaskCompletion(context),
              if (!ResponsiveHelper.isDesktop(context))
                SizedBox(height: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 24.0,
                  tablet: 32.0,
                  desktop: 40.0,
                )),
              if (!ResponsiveHelper.isDesktop(context))
                _buildProductivityTrend(context),
              if (!ResponsiveHelper.isDesktop(context))
                SizedBox(height: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 24.0,
                  tablet: 32.0,
                  desktop: 40.0,
                )),
              if (!ResponsiveHelper.isDesktop(context))
                _buildCategoryBreakdown(context),
              if (ResponsiveHelper.isDesktop(context))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildProductivityScore(context)),
                    const SizedBox(width: 32),
                    Expanded(flex: 3, child: _buildTaskCompletion(context)),
                  ],
                ),
              if (ResponsiveHelper.isDesktop(context))
                const SizedBox(height: 32),
              if (ResponsiveHelper.isDesktop(context))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildProductivityTrend(context)),
                    const SizedBox(width: 32),
                    Expanded(child: _buildCategoryBreakdown(context)),
                  ],
                ),
            ],
        ),
      ),
    );
  }

  Widget _buildProductivityScore(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productivity Score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      strokeWidth: 12,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '75%',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'Great!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCompletion(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Completion',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildProgressBar(
              context,
              'Completed',
              0.8,
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildProgressBar(
              context,
              'In Progress',
              0.15,
              Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildProgressBar(
              context,
              'Overdue',
              0.05,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${(value * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildProductivityTrend(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productivity Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Chart will be implemented here',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildCategoryItem(context, 'Work', 0.4, Colors.blue),
            _buildCategoryItem(context, 'Personal', 0.3, Colors.green),
            _buildCategoryItem(context, 'Shopping', 0.2, Colors.orange),
            _buildCategoryItem(context, 'Health', 0.1, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String category,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(category),
          const Spacer(),
          Text('${(percentage * 100).toInt()}%'),
        ],
      ),
    );
  }
}
