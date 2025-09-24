import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? user?.email ?? 'Solace User';
    final userEmail = user?.email ?? 'No Email';

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // User Avatar and Name
        Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Text(
                  displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : 'S',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 40),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                displayName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                userEmail,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Account Settings
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.primary),
                title: Text('Change Password'),
                onTap: () {
                  // TODO: Implement password change functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Change password (Not implemented)')),
                  );
                },
              ),
              Divider(color: Theme.of(context).colorScheme.surface.withOpacity(0.5), height: 1),
              ListTile(
                leading: Icon(Icons.data_usage, color: Theme.of(context).colorScheme.primary),
                title: Text('Privacy Settings'),
                onTap: () {
                  // TODO: Implement privacy settings (e.g., delete data)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy settings (Not implemented)')),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Emergency Resources
        Card(
          child: ListTile(
            leading: Icon(Icons.medical_services_outlined, color: Theme.of(context).colorScheme.error),
            title: Text('Emergency Mental Health Resources'),
            trailing: Icon(Icons.open_in_new, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            onTap: () {
              // TODO: Open a web view or external link to resources
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening emergency resources (Not implemented)')),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // About & Logout
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                title: Text('About Solace'),
                onTap: () {
                  // TODO: Show About dialog
                  showAboutDialog(
                    context: context,
                    applicationName: 'Solace',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2023 Solace App',
                    children: [
                      Text('Your AI-powered conversational wellness companion.'),
                    ],
                  );
                },
              ),
              Divider(color: Theme.of(context).colorScheme.surface.withOpacity(0.5), height: 1),
              ListTile(
                leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                title: Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: Text(
            'App Version 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                ),
          ),
        ),
      ],
    );
  }
}
