import 'package:app4_receitas/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  // Retorna o usuário atual 
  User? get currentUser => _supabaseClient.auth.currentUser;

  // Realiza o login com email e senha
  Future<AuthResponse> signInWithPassword({
    required String email, 
    String password,
    }) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
    
    if (response.error != null) {
      throw Exception('Erro ao fazer login: ${response.error!.message}');
    }
  }

  // Realiza o logout do usuário
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  // Verifica se o usuário está autenticado
  bool get isAuthenticated => currentUser != null;
}