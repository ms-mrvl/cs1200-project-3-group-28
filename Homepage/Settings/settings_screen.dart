import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() => notificationsEnabled = val);
            },
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
              // TODO: Add theme switching
            },
          ),
        ],
      ),
    );
  }
}
