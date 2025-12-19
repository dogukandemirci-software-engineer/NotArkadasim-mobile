import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_classic_appbar/NA_classic_appbar.dart';


class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});


  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}


class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String _selected = 'Türkçe';
  final _options = ['Türkçe', 'English'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Dil ayarları"),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: _options.map((lang) {
          return RadioListTile<String>(
            title: Text(lang),
            value: lang,
            activeColor: Colors.purple,
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v!),
          );
        }).toList(),
      ),
    );
  }
}