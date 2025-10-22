import 'package:flutter/material.dart';


class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});


  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}


class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _profilePublic = true;
  bool _shareUsage = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            title: const Text('Make profile public'),
            value: _profilePublic,
            onChanged: (v) => setState(() => _profilePublic = v),
          ),
          SwitchListTile(
            title: const Text('Share anonymized usage data'),
            value: _shareUsage,
            onChanged: (v) => setState(() => _shareUsage = v),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Changes saved (mock)'))),
            child: const Text('Save Settings'),
          )
        ],
      ),
    );
  }
}