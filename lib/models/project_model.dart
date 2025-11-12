class Project {
  final int? id;
  final String title;
  final String description;
  final int creatorId;
  final String category;
  final String status; // e.g., Active, Completed
  final int isPublic; // 1 or 0
  final String createdAt;

  Project({
    this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.category,
    this.status = 'Active',
    this.isPublic = 1,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'creator_id': creatorId,
    'category': category,
    'status': status,
    'is_public': isPublic,
    'created_at': createdAt,
  };

  factory Project.fromMap(Map<String, dynamic> m) => Project(
    id: m['id'],
    title: m['title'],
    description: m['description'],
    creatorId: m['creator_id'],
    category: m['category'] ?? 'General',
    status: m['status'] ?? 'Active',
    isPublic: m['is_public'] ?? 1,
    createdAt: m['created_at'] ?? '',
  );
}
