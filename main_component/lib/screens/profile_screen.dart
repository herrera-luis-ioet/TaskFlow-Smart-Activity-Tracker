import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/responsive_builder.dart';

/// ProfileScreen displays user profile and app settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.responsivePadding(context),
        child: ResponsiveBuilder(
          mobile: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              SizedBox(height: ResponsiveHelper.responsiveValue(
                context,
                mobile: 24,
                tablet: 32,
                desktop: 40,
              )),
              _buildSettings(context),
              SizedBox(height: ResponsiveHelper.responsiveValue(
                context,
                mobile: 24,
                tablet: 32,
                desktop: 40,
              )),
              _buildStatistics(context),
            ],
          ),
          tablet: Column(
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildSettings(context)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildStatistics(context)),
                ],
              ),
            ],
          ),
          desktop: Column(
            children: [
              SizedBox(
                width: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: double.infinity,
                  tablet: 600,
                  desktop: 800,
                ),
                child: _buildProfileHeader(context),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildSettings(context)),
                  const SizedBox(width: 32),
                  Expanded(child: _buildStatistics(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.responsiveValue(
          context,
          mobile: 16.0,
          tablet: 24.0,
          desktop: 32.0,
        )),
        child: Row(
          children: [
            CircleAvatar(
              radius: ResponsiveHelper.responsiveValue(
                context,
                mobile: 40,
                tablet: 50,
                desktop: 60,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(width: ResponsiveHelper.responsiveValue(
              context,
              mobile: 16.0,
              tablet: 24.0,
              desktop: 32.0,
            )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Implement edit profile
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (bool value) {
                // TODO: Implement theme toggle
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // TODO: Implement notifications toggle
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Text('English'),
            onTap: () {
              // TODO: Implement language selection
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Tasks Completed'),
            trailing: const Text('156'),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Average Completion Time'),
            trailing: const Text('2.5 days'),
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Productivity Score'),
            trailing: const Text('85%'),
          ),
        ],
      ),
    );
  }
}
