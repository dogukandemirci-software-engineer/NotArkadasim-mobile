import 'package:flutter/material.dart';
import 'package:note_arkadasim/routes/routes.dart';

import '../../../../../services/navigation_service/navigation_service.dart';


class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Personal Information'),
              subtitle: const Text('Name, email and bio'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => NavigationService.instance.go(AppRoutes.personalInformation),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Profile visibility & data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => NavigationService.instance.go(AppRoutes.privacySettings),
            ),
          ),
        ],
      ),
    );
  }
}