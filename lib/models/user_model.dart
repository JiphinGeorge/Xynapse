class AppUser {
  final int? id;
  final String name;
  final String email;

  AppUser({this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
  };

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
    id: m['id'],
    name: m['name'],
    email: m['email'],
  );
}
