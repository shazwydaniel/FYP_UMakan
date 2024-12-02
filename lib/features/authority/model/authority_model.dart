class AuthorityModel {
  final String id;
  final String username;
  final String email;
  final String role;

  AuthorityModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory AuthorityModel.fromJson(Map<String, dynamic> json) {
    return AuthorityModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}