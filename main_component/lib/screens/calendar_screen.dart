import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/responsive_helper.dart';
import '../widgets/responsive_builder.dart';

/// CalendarScreen displays a calendar view of tasks and deadlines.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calendar',
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
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildCalendarWidget(context),
        Expanded(
          child: _buildEventsList(context),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildCalendarWidget(context),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: _buildEventsList(context),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildCalendarWidget(context),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: _buildEventsList(context),
        ),
      ],
    );
  }

  Widget _buildCalendarWidget(BuildContext context) {
    return Card(
      margin: ResponsiveHelper.responsivePadding(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {},
                ),
                Text(
                  'March 2024',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              return Center(
                child: Text('${index + 1}'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(BuildContext context) {
    return ListView.builder(
      padding: ResponsiveHelper.responsivePadding(context),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Event ${index + 1}'),
            subtitle: const Text('10:00 AM - 11:00 AM'),
            leading: const Icon(Icons.event),
            trailing: const Icon(Icons.more_vert),
            onTap: () {},
          ),
        );
      },
    );
  }
}
