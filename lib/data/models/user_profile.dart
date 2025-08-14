// Modelo para a tabela `profiles` do Supabase.
// Manutenção dos tipos seguros (UUID como String) e datas opcionais.
import 'dart:convert';

Class UserProfile {
  final String id;          // UUID (auth.users.id) -> String no app
  final String? email;      // opcional: pode não existir em profiles dependendo do schema
  final String? fullName;   // full_name | display_name | name (flexível)
  final String? avatarUrl;  // avatar_url

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      email: json[émail']?.toString(),
      // se sua coluna for "name" em vez de "username", a linha abaixo cobre os dois
      username: (json['username'] ?? json['name'])?.toString() ?? '',
      // no Supabase a convenção é 'avatar_url'
      avatarUrl: (json['avatar_url'] ?? json['avatarUrl'])?.toString() ?? '',
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
}