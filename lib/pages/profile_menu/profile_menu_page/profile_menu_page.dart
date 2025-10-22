import 'package:flutter/material.dart';
import '../../../services/navigation_service/navigation_service.dart';

class ProfileMenuPage extends StatefulWidget {
  const ProfileMenuPage({super.key});

  @override
  State<ProfileMenuPage> createState() => _ProfileMenuPageState();
}

class _ProfileMenuPageState extends State<ProfileMenuPage> {
  final List<_ProfileMenuItem> menuItems = [
    // Ana kategoriler
    _ProfileMenuItem(
      title: "My Notes",
      route: "/my-notes",
      icon: Icons.note_alt_outlined,
    ),
    _ProfileMenuItem(
      title: "Liked Notes",
      route: "/liked-notes",
      icon: Icons.favorite_outline,
    ),
    _ProfileMenuItem(
      title: "Comments",
      route: "/comments",
      icon: Icons.comment_outlined,
    ),
    _ProfileMenuItem(
      title: "Scores",
      route: "/scores",
      icon: Icons.emoji_events_outlined,
    ),

    // App settings bölümü
    _ProfileMenuItem(
      title: "App Settings",
      route: "/app-settings",
      icon: Icons.settings_outlined,
      subItems: [
        _ProfileMenuItem(
          title: "Account Settings",
          route: "/app-settings/account-settings",
          icon: Icons.person_outline,
          subItems: [
            _ProfileMenuItem(
              title: "Personal Information",
              route: "/app-settings/account-settings/personal-information",
              icon: Icons.info_outline,
            ),
            _ProfileMenuItem(
              title: "Privacy Settings",
              route: "/app-settings/account-settings/privacy-settings",
              icon: Icons.lock_outline,
            ),
          ],
        ),
        _ProfileMenuItem(
          title: "Language Settings",
          route: "/app-settings/language-settings",
          icon: Icons.language_outlined,
        ),
        _ProfileMenuItem(
          title: "Notification Settings",
          route: "/app-settings/notification-settings",
          icon: Icons.notifications_outlined,
        ),
        _ProfileMenuItem(
          title: "Theme Settings",
          route: "/app-settings/theme-settings",
          icon: Icons.color_lens_outlined,
        ),
      ],
    ),
  ];

  void _navigateTo(String route) {
    NavigationService.instance.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: ListView(
        children: menuItems.map((item) => _buildMenuItem(item)).toList(),
      ),
    );
  }

  Widget _buildMenuItem(_ProfileMenuItem item, {int indentLevel = 0}) {
    final hasChildren = item.subItems.isNotEmpty;

    return ExpansionTile(
      leading: Icon(item.icon),
      title: Padding(
        padding: EdgeInsets.only(left: indentLevel * 12.0),
        child: Text(item.title),
      ),
      children: hasChildren
          ? item.subItems
          .map(
            (subItem) => _buildMenuItem(subItem, indentLevel: indentLevel + 1),
      )
          .toList()
          : [],
      onExpansionChanged: (expanded) {
        if (!hasChildren) _navigateTo(item.route);
      },
    );
  }
}

class _ProfileMenuItem {
  final String title;
  final String route;
  final IconData icon;
  final List<_ProfileMenuItem> subItems;

  const _ProfileMenuItem({
    required this.title,
    required this.route,
    required this.icon,
    this.subItems = const [],
  });
}
