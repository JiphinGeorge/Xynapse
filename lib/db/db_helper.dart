import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/project_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'xynapse.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE projects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        creator_id INTEGER,
        category TEXT,
        status TEXT,
        is_public INTEGER,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE collaborations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        project_id INTEGER,
        user_id INTEGER
      )
    ''');

    // Insert 5 dummy users
    final users = [
      AppUser(name: 'Akhil', email: 'akhil@example.com'),
      AppUser(name: 'Merin', email: 'merin@example.com'),
      AppUser(name: 'Ankith', email: 'ankith@example.com'),
      AppUser(name: 'Sivalekshmi', email: 'sivalekshmi@example.com'),
      AppUser(name: 'Jiphin', email: 'jiphin@example.com'),
    ];
    for (var u in users) {
      await db.insert('users', u.toMap());
    }

    // sample project to show on first run
    await db.insert('projects', {
      'title': 'Campus Cleanup',
      'description': 'Organize a campus cleaning drive.',
      'creator_id': 1,
      'category': 'Social',
      'status': 'Active',
      'is_public': 1,
      'created_at': DateTime.now().toIso8601String(),
    });

    // join sample
    await db.insert('collaborations', {'project_id': 1, 'user_id': 2});
    await db.insert('collaborations', {'project_id': 1, 'user_id': 3});
  }

  // CRUD Projects
  Future<int> insertProject(Project project) async {
    final db = await database;
    final id = await db.insert('projects', project.toMap());
    // add creator as collaborator too
    await db.insert('collaborations', {'project_id': id, 'user_id': project.creatorId});
    return id;
  }

  Future<List<Project>> getAllProjects() async {
    final db = await database;
    final res = await db.query('projects', orderBy: 'created_at DESC');
    return res.map((m) => Project.fromMap(m)).toList();
  }

  Future<List<Project>> getProjectsByCreator(int userId) async {
    final db = await database;
    final res = await db.query('projects', where: 'creator_id = ?', whereArgs: [userId]);
    return res.map((m) => Project.fromMap(m)).toList();
  }

  Future<int> updateProject(Project p) async {
    final db = await database;
    return db.update('projects', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  Future<int> deleteProject(int id) async {
    final db = await database;
    await db.delete('collaborations', where: 'project_id = ?', whereArgs: [id]);
    return db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }

  // Collaborations
  Future<List<AppUser>> getProjectMembers(int projectId) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT u.* FROM users u
      JOIN collaborations c ON c.user_id = u.id
      WHERE c.project_id = ?
    ''', [projectId]);
    return res.map((m) => AppUser.fromMap(m)).toList();
  }

  Future<int> addCollaboration(int projectId, int userId) async {
    final db = await database;
    // avoid duplicates
    final exists = await db.query('collaborations',
        where: 'project_id = ? AND user_id = ?', whereArgs: [projectId, userId]);
    if (exists.isNotEmpty) return 0;
    return db.insert('collaborations', {'project_id': projectId, 'user_id': userId});
  }

  Future<int> removeCollaboration(int projectId, int userId) async {
    final db = await database;
    return db.delete('collaborations',
        where: 'project_id = ? AND user_id = ?', whereArgs: [projectId, userId]);
  }

  Future<List<AppUser>> getAllUsers() async {
    final db = await database;
    final res = await db.query('users');
    return res.map((m) => AppUser.fromMap(m)).toList();
  }
}
