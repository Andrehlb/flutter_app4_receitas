// import 'package:dartz/dartz.dart';
// import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/utils/app_error.dart';

class AuthService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  // Retorna o Usuário atual (null se não autenticado)
  User? get currentUser => _supabaseClient.auth.currentUser;
  //bool get isLoggedIn => currentUser != null;
  //bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  // Stream para "ouvir" mudanças no estado de autenticação
  Stream<AuthState> get authStateChanges => _supabaseClient.auth.onAuthStateChange;

  // Sign in with email and pass
  // 1) método com either (no estilo do Guilehrme)
  // Esquerda = AppError (falha) | Direita = AuthResponse (sucesso)
  Future<Either<AppError, AuthResponse>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Right(response); // Sucesso -> Right
    } on AuthException catch (e) {
      switch (e.message) {
        case 'invalid login credentials':
          return Left(
            AppError('Credenciais inválidas. Verifique seu e-mail e senha.'));
        case 'email not confirmed':
          return Left(AppError('E-mail não confirmado. Verifique sua caixa de entrada.'));
        default:
          return Left(AppError('Erro ao fazer login: ${e.message}'));
      }
