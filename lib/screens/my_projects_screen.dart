import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';

class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProjectProvider>(context);
    final items = prov.myProjects;
    return Scaffold(
      appBar: AppBar(title: const Text('My Projects')),
      body: items.isEmpty
        ? const Center(child: Text('You have not created any projects yet.'))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) => ProjectCard(project: items[i], isOwner: true),
          ),
    );
  }
}
