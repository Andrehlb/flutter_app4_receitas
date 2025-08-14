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
  
  // Realiza o logout do usuário
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  // Verifica se o usuário está autenticado
  bool get isAuthenticated => currentUser != null;
}