import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:either_dart/either.dart';
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
  }) {
    return _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
    
  // Login “seguro” (novo): retorna Either<erro, sucesso>
  Future<Either<String, AuthResponse>> signInWithPasswordSafe({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Right(res);
    } on AuthException catch (e) {
      return Left(_mapAuthError(e));
    } catch (_) {
      return const Left('Falha ao autenticar. Tente novamente.');
    }
  }

  // Cadastro (mantido do passo anterior)
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
        // Pode falhar por RLS se e-mail não confirmado; esperado no fluxo da aula.
      }
    }

    return res;
  }

  Future<void> signOut() => _supabaseClient.auth.signOut();

  Future<UserProfile?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final row = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (row == null) return null;
    return UserProfile.fromJson((row as Map).cast<String, dynamic>());
  }

  Future<UserProfile?> getProfileById(String uid) async {
    final row = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (row == null) return null;
    return UserProfile.fromJson((row as Map).cast<String, dynamic>());
  }

  Future<void> upsertProfile(UserProfile profile) async {
    await _supabaseClient.from('profiles').upsert(profile.toJson());
  }

  // Mapeia erros comuns do Supabase Auth para mensagens claras
  String _mapAuthError(AuthException e) {
    final msg = (e.message ?? '').toLowerCase();

    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid login') ||
        msg.contains('invalid credentials')) {
      return 'Credenciais inválidas. Verifique e-mail e senha.';
    }

    if (msg.contains('email not confirmed') ||
        msg.contains('email not confirmed') ||
        msg.contains('email confirmation required')) {
      return 'E-mail não confirmado. Verifique sua caixa de entrada.';
    }

    if (msg.contains('over_email_send_rate_limit')) {
      return 'Limite de envios de e-mail atingido. Aguarde alguns minutos.';
    }

    if (msg.contains('user not found') || msg.contains('no user found')) {
      return 'Usuário não encontrado.';
    }

    // Fallback
    return 'Falha ao autenticar: ${e.message}';
  }
}