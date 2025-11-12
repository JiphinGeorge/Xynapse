import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_helper.dart';
import '../models/project_model.dart';
import '../models/user_model.dart';

class ProjectProvider extends ChangeNotifier {
  final DBHelper _db = DBHelper();
  List<Project> projects = [];
  List<Project> myProjects = [];
  List<Project> collaborations = [];
  List<AppUser> users = [];
  int currentUserId = 1;

  Future<void> init() async {
    await _loadUsers();
    await _loadPrefs();
    await refreshAll();
  }

  Future<void> _loadUsers() async {
    users = await _db.getAllUsers();
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    currentUserId = sp.getInt('current_user') ?? 1;
  }

  Future<void> setCurrentUser(int id) async {
    currentUserId = id;
    final sp = await SharedPreferences.getInstance();
    await sp.setInt('current_user', id);
    await refreshAll();
    notifyListeners();
  }

  Future<void> refreshAll() async {
    projects = await _db.getAllProjects();
    myProjects = await _db.getProjectsByCreator(currentUserId);
    // collaborations: projects which have current user as collaborator
    final all = await _db.getAllProjects();
    final coll = <Project>[];
    for (var p in all) {
      final members = await _db.getProjectMembers(p.id!);
      if (members.any((u) => u.id == currentUserId) && p.creatorId != currentUserId) {
        coll.add(p);
      }
    }
    collaborations = coll;
    notifyListeners();
  }

  Future<int> addProject(Project p, List<int> memberIds) async {
    final id = await _db.insertProject(p);
    for (var uid in memberIds) {
      await _db.addCollaboration(id, uid);
    }
    await refreshAll();
    return id;
  }

  Future<void> joinProject(int projectId) async {
    await _db.addCollaboration(projectId, currentUserId);
    await refreshAll();
  }

  Future<void> leaveProject(int projectId) async {
    await _db.removeCollaboration(projectId, currentUserId);
    await refreshAll();
  }

  Future<List<AppUser>> getMembers(int projectId) async {
    return await _db.getProjectMembers(projectId);
  }

  Future<void> deleteProject(int projectId) async {
    await _db.deleteProject(projectId);
    await refreshAll();
  }
}
