import 'package:flutter/material.dart';


class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});


  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}


class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  bool _dark = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Use dark theme'),
              value: _dark,
              onChanged: (v) => setState(() => _dark = v),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Preview', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_dark ? 'Dark preview active' : 'Light preview active'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}