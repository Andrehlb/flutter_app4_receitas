// import 'package:dartz/dartz.dart';
// import 'package:app4_receitas/di/service_locator.dart';
// import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app4_receitas/services/auth_service.dart';
import 'package:app4_receitas/utils/app_error.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Usuário atual (null se não autenticado)
  User? get currentUser => _supabaseClient.auth.currentUser;
  //bool get isLoggedIn => currentUser != null;
  //bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  // 1) método com either (no estilo do Guilehrme)
  // Esquerda = AppError (falha) | Direita = AuthResponse (sucesso)
  Future<Either<AppError, AuthResponse>> signInWithPasswordSafe({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return either.Right(response); // Sucesso -> Right
    } on AuthException catch (e) {
      final msg = e.message?.toLowerCase() ?? '';

      if (msg.contains('invalid login credentials')) {
        return either.Left(AppError('E-mail não confirmado. Verifique sua caixa de entrada e confirme, por favor..', e));
      } // if do invalid login credentials
      //default:
      if (msg.contains('email not confirmed')) {
        return either.Left(AppError('Veja sua caixa de entrada e faça a confirmação antes de entrar: ${e.message}'));
      } // if do email not confirmed

      // Fallback para outros erros
      return either.Left(AppError('Falha ao tentar acessar: ${e.message}'));
    } catch (e) {
      // Erro inesperado
      return either.Left(AppError('Erro inesperado ao tentar acessar: $e'));
    } // catch
  } // Future...signInWithPasswordSafe

  Future<void> signOut() async{
    await _supabaseClient.auth.signOut();
  } // Future<void> signOut
} // class AuthService