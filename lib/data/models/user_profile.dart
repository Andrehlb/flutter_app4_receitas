// Modelo para a tabela `profiles` do Supabase.
// Manutenção dos tipos seguros (UUID como String) e datas opcionais.
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
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_Url'] as String,
    );
  }

