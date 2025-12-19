import 'package:flutter/material.dart';
import '../../../../routes/routes.dart';
import '../../../../services/navigation_service/navigation_service.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Settings')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Account Settings',
            subtitle: 'Personal info & privacy',
            onTap: () => NavigationService.instance.go(AppRoutes.accountSettings),
          ),
          _SettingsTile(
            icon: Icons.language,
            title: 'Language Settings',
            subtitle: 'Choose app language',
            onTap: () => NavigationService.instance.go(AppRoutes.languageSettings),
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notification Settings',
            subtitle: 'Push & email preferences',
            onTap: () => NavigationService.instance.go(AppRoutes.notificationSettings),
          ),
          _SettingsTile(
            icon: Icons.color_lens_outlined,
            title: 'Theme Settings',
            subtitle: 'Light / Dark',
            onTap: () => NavigationService.instance.go(AppRoutes.themeSettings),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'SSS',
            subtitle: 'Light / Dark',
            onTap: () => NavigationService.instance.go(AppRoutes.sssPage),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
