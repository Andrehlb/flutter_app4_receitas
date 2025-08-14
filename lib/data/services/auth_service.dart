import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  // Usuário atual (null se não autenticado)
  User? get currentUser => _supabaseClient.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  // Cadastro com e-mail/senha. Observação: dependendo da config, pode exigir confirmação por e-mail.
  Future<AuthResponse> signUpEmailPassword({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) async {
    final res = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {
        if (username != null && username.isNotEmpty) 'username': username,
        if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatar_url': avatarUrl,
      },
    );
    
    // Se já houver user, tentamos sincronizar a linha em profiles (RLS pode exigir e-mail confirmado)
    final user = res.user;
    if (user != null) {
      try {
        await _supabaseClient.from('profiles').upsert({
          'id': user.id,
          'email': user.email,
          if (username != null && username.isNotEmpty) 'username': username,
          if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatar_url': avatarUrl,
        });
      } catch (_) {
        // Pode falhar por RLS se o e-mail ainda não estiver confirmado. Isso é esperado no fluxo da aula.
      }
    }

    return res;
  }

  // Login com e-mail e senha
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Perfil do usuário autenticado (tabela profiles)
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final row = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

  // Verifica se o usuário está autenticado
  bool get isAuthenticated => currentUser != null;
}