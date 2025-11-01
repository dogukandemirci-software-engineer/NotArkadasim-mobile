import 'package:flutter/material.dart';


class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});


  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}


class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _profilePublic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            activeColor: Colors.purple,
            title: const Text('Make profile public'),
            value: _profilePublic,
            onChanged: (v) => setState(() => _profilePublic = v),
          ),
        ],
      ),
    );
  }
}