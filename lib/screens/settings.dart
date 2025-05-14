import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF116466), Color(0xFF23272F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            title: const Text(
              'Enable Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            activeColor: const Color(0xFF116466),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          const Divider(color: Colors.white30),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.white),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            onTap: () {
              // Placeholder: implement Privacy Policy action
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF23272F),
    );
  }
}
