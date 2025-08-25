import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/utils/app_error.dart';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  // Retorna o usuário atual
  User? get currentUser => _supabaseClient.auth.currentUser;

// Stream para ouvir mudanças na autenticação
  Stream<AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;

// Sign in com email e password
  Future<Either<AppError, AuthResponse>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Right(response);
    } on AuthException catch (e) {
      switch (e.message) {
        case 'Invalid login credentials':
          return Left(
            AppError('Usuário não cadastrado ou credenciais inválidas'),
          );
        case 'Email not confirmed':
          return Left(AppError('E-mail não confirmado'));
        default:
          return Left(AppError('Erro ao fazer login', e));
      }
    }
  }

  // Retorna os valores da tabela profile
  Future<Either<AppError, Map<String, dynamic>?>> fetchUserProfile(
    String userId,
  ) async {
    try {
      final profile = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return Right(profile);
    } catch (e) {
      return Left(AppError('Erro ao carregar profile'));
    }
  }

  // Sign Up - Registro de novo usuário
  }

  // Sign in - Registro do usuário
  Future<Either<AppError, AuthResponse>> signUp({
     required String email,
    required String password,
    required String username,
    required String avatarUrl,
  }) async {
    try {
      // Verificar se o username já está em uso
      final existingUser = await _supabaseClient
          .from('profiles')
          .select()
          .eq('username', username)
          .maybeSingle();

      if (existingUser != null) {
        return Left(AppError('Vixi! Já tem alguém que usa este nome de usuário. \nRapidinho você escolhe outro'));
      }

      final result = await insertUser(email: email, password: password);
      return result.fold((left) => Left(left), (right) async {
        await _supabaseClient.from('profiles').insert({
          'id': result.right.user!.id,
          'username': username,
          'avatar_url': avatarUrl,
        }); // supabase and insert
        return Right(right);
      }); // return result.fold
    } on PostgrestException catch (e) {
      switch(e.code) {
        case '23505': // Unique violation
          return Left(AppError('Hey! Este e-mail já está cadastrado.'));
        default:
          return Left(AppError('Hum! Deu ruim o registro: ${e.message}, tem que fazer de novo'));
      } // switch
    } catch (e) {
      return Left(AppError('Aconteceu um erro inesperado ao registrar ${e.toString()}'));
    } // catch
  } // async

  Future<Either<AppError, AuthResponse>> insertUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      return Right(response);
    } on AuthException catch (e) {
      switch (e.message) {
        case 'Email not confirmed':
          return Left(
            AppError('Oi! Este e-mail ainda não foi confirmado. Por favor, veja tua caixa de entrada.'),
          );
        default:
          return Left(AppError('Hum! Aconteceu um erro ao registrar: ${e.message}, tenta de novo por favor.'));
      } // switch
    } // on AuthException
  } // insertUser and async

  Future<Either<AppError, void>> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      return Right(null); // Sucesso
    } on AuthException catch (e) {
      return Left(AppError('Hum! Aconteceu um erro ao sair ${e.message}'));
    } catch (e) {
      return Left(AppError('Hum!, ainda está acontecendo um erro ao sair ${e.toString()}'));
    } // catch
  } // 
} // class AuthService