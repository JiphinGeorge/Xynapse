import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';
import 'add_edit_project_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProjectProvider>(context);
    final items = prov.projects.where((p) =>
      p.title.toLowerCase().contains(query.toLowerCase()) ||
      p.category.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('XYNAPSE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => prov.refreshAll(),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search projects or categories...',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: items.isEmpty
              ? const Center(child: Text('No projects yet. Add one!'))
              : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) => ProjectCard(project: items[i]),
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditProjectScreen()));
          prov.refreshAll();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
