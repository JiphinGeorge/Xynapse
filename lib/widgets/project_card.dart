import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../providers/project_provider.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool isOwner;
  const ProjectCard({super.key, required this.project, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProjectProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(project.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(project.category),
            const SizedBox(height: 6),
            FutureBuilder(
              future: prov.getMembers(project.id!),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox.shrink();
                final members = snap.data!;
                return Text('${members.length} members', style: const TextStyle(fontSize: 12));
              },
            )
          ],
        ),
        onTap: () => _showDetails(context),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return FutureBuilder(
          future: Provider.of<ProjectProvider>(context, listen: false).getMembers(project.id!),
          builder: (context, snap) {
            final members = snap.data ?? [];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(project.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(project.description),
                const SizedBox(height: 12),
                Text('Category: ${project.category}'),
                const SizedBox(height: 8),
                Text('Members: ${members.map((m) => m.name).join(', ')}'),
                const SizedBox(height: 12),
                Row(children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Provider.of<ProjectProvider>(context, listen: false).joinProject(project.id!);
                      Navigator.pop(context);
                    },
                    child: const Text('Join'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      await Provider.of<ProjectProvider>(context, listen: false).leaveProject(project.id!);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Leave'),
                  ),
                ])
              ]),
            );
          },
        );
      },
    );
  }
}
