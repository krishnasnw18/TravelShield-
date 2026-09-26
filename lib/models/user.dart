enum UserRole { tourist, police, admin }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role.name,
    'profileImage': profileImage,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: UserRole.values.firstWhere((role) => role.name == json['role']),
    profileImage: json['profileImage'],
  );
}