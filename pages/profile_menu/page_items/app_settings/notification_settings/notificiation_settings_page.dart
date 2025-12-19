import 'package:flutter/material.dart';

import '../../../../../components/NA_classic_appbar/NA_classic_appbar.dart';

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
      appBar: buildAppBar(context,"Bildirim ayarları"),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(activeColor: Colors.purple,title: const Text('Push Notifications'), value: _push, onChanged: (v) => setState(() => _push = v)),
        ],
      ),
    );
  }
}