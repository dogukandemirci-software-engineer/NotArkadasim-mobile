import 'package:flutter/material.dart';


class NotificiationSettingsPage extends StatefulWidget {
  const NotificiationSettingsPage({super.key});


  @override
  State<NotificiationSettingsPage> createState() => _NotificiationSettingsPageState();
}


class _NotificiationSettingsPageState extends State<NotificiationSettingsPage> {
  bool _push = true;
  bool _email = true;
  bool _sms = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(title: const Text('Push Notifications'), value: _push, onChanged: (v) => setState(() => _push = v)),
          SwitchListTile(title: const Text('Email Notifications'), value: _email, onChanged: (v) => setState(() => _email = v)),
          SwitchListTile(title: const Text('SMS Notifications'), value: _sms, onChanged: (v) => setState(() => _sms = v)),
        ],
      ),
    );
  }
}