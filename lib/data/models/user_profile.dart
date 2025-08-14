// Modelo para a tabela `profiles` do Supabase.
// Manutenção dos tipos seguros (UUID como String) e datas opcionais.
import 'dart:convert';

Class UserProfile {
  final String id;          // UUID (auth.users.id) -> String no app
  final String? email;      // opcional: pode não existir em profiles dependendo do schema
  final String? fullName;   // full_name | display_name | name (flexível)
  final String? avatarUrl;  // avatar_url
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    this.name,
    this.email,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      email: json[émail']?.toString(),
      // para suportar diferentes nomes de campo: full_name, display_name, name
      fullName: (json['full_name'] ?? json['display_name'] ?? json['name'])?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
