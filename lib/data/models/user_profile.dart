// Modelo para a tabela `profiles` do Supabase.
// Manutenção dos tipos seguros (UUID como String) e datas opcionais.
//import 'dart:convert';

class UserProfile {
  final String id;          // UUID (auth.users.id) -> String no app
  final String? email;      // opcional: pode não existir em profiles dependendo do schema
  final String? username;   // full_name | display_name | name (flexível)
  final String? avatarUrl;  // avatar_url

  const UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      // se sua coluna for "name" em vez de "username", a linha abaixo cobre os dois
      username: json['username']  as String,
      // no Supabase a convenção é 'avatar_url'
      avatarUrl: json['avatar_url'] as String,
    );
  }

  factory UserProfile.fromSupabase(
    Map<String, dynamic> userData,
    Map<String, dynamic> profileData
  ) {
    return UserProfile(
      id: userData['id'] ??'',
      email: userData['email'] ?? '',
      username: profileData['username'] ?? '',
      avatarUrl: profileData['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
    };
  }

  @override
  String toString() {
    return 'UserProfile(username: $username)';
  }
}