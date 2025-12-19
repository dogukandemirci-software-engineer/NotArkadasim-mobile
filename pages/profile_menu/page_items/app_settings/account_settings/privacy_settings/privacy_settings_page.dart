import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_classic_appbar/NA_classic_appbar.dart';


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
      appBar: buildAppBar(context, "Gizlilik Ayarları"),
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