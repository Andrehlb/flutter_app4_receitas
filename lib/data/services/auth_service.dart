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

    if (row == null) return null;
    return UserProfile.fromJson((row as Map).cast<String, dynamic>());
  }

  // Buscar perfil por id
  Future<UserProfile?> getProfileById(String uid) async {
    final row = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (row == null) return null;
    return UserProfile.fromJson((row as Map).cast<String, dynamic>());
  }

  // Criar/atualizar perfil (usado após confirmação de e-mail)
  Future<void> upsertProfile(UserProfile profile) async {
    await _supabaseClient.from('profiles').upsert(profile.toJson());
  }
}