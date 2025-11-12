import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProjectProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Switch User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButton<int>(
              value: prov.currentUserId,
              items: prov.users.map((u) => DropdownMenuItem(value: u.id, child: Text(u.name))).toList(),
              onChanged: (v) {
                if (v != null) prov.setCurrentUser(v);
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Your ID'),
              subtitle: Text('${prov.currentUserId}'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => prov.refreshAll(),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Data'),
            )
          ],
        ),
      ),
    );
  }
}
