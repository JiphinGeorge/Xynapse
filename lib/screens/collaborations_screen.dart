import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';

class CollaborationsScreen extends StatelessWidget {
  const CollaborationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProjectProvider>(context);
    final items = prov.collaborations;
    return Scaffold(
      appBar: AppBar(title: const Text('Collaborations')),
      body: items.isEmpty
        ? const Center(child: Text('No collaborative projects yet.'))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) => ProjectCard(project: items[i]),
          ),
    );
  }
}
