Class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_Url'] as String,
    );
  }

