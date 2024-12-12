import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
          
        ),
        iconTheme: const IconThemeData(color: Colors.white),

        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'General',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _buildSettingsTile(
                icon: Icons.person,
                title: 'Account',
                subtitle: 'Manage your account settings',
                onTap: () {
                  // Navigate to account settings
                },
              ),
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Notification preferences',
                onTap: () {
                  // Navigate to notification settings
                },
              ),
              _buildSettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Change app language',
                onTap: () {
                  // Navigate to language settings
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Privacy & Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _buildSettingsTile(
                icon: Icons.lock,
                title: 'Privacy',
                subtitle: 'Privacy preferences',
                onTap: () {
                  // Navigate to privacy settings
                },
              ),
              _buildSettingsTile(
                icon: Icons.shield,
                title: 'Security',
                subtitle: 'Manage security settings',
                onTap: () {
                  // Navigate to security settings
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Other',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _buildSettingsTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help and support',
                onTap: () {
                  // Navigate to help & support
                },
              ),
              _buildSettingsTile(
                icon: Icons.info,
                title: 'About',
                subtitle: 'About the app',
                onTap: () {
                  // Navigate to about screen
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: false, // Replace with a dynamic value
                onChanged: (value) {
                  // Handle theme change
                },
                secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.indigo),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }
}

