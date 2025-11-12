import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/project_model.dart';

class AddEditProjectScreen extends StatefulWidget {
  const AddEditProjectScreen({super.key});
  @override
  State<AddEditProjectScreen> createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen> {
  final _form = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  String category = 'General';
  bool isPublic = true;
  final List<int> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProjectProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Project')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => (v==null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: descCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Description'), validator: (v) => (v==null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: ['General','Tech','Design','Social','Academic'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => category = v ?? 'General'),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              const Text('Add Collaborators (optional)'),
              Wrap(
                spacing: 8,
                children: prov.users.map((u) {
                  final selected = selectedUsers.contains(u.id);
                  return FilterChip(
                    label: Text(u.name),
                    selected: selected,
                    onSelected: (s) {
                      setState(() {
                        if (s) selectedUsers.add(u.id!);
                        else selectedUsers.remove(u.id);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Public Project'),
                value: isPublic,
                onChanged: (v) => setState(() => isPublic = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_form.currentState!.validate()) return;
                  final now = DateTime.now().toIso8601String();
                  final p = Project(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    creatorId: prov.currentUserId,
                    category: category,
                    isPublic: isPublic ? 1 : 0,
                    createdAt: now,
                  );
                  final id = await prov.addProject(p, selectedUsers);
                  Navigator.pop(context);
                },
                child: const Text('Create Project'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
