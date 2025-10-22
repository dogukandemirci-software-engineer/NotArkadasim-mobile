import 'package:flutter/material.dart';


class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});


  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}


class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String _selected = 'Türkçe';
  final _options = ['Türkçe', 'English', 'Deutsch', 'Español'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Settings')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: _options.map((lang) {
          return RadioListTile<String>(
            title: Text(lang),
            value: lang,
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v!),
          );
        }).toList(),
      ),
    );
  }
}