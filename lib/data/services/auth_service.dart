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
          return Left(AppError('E-mail ou senha incorretos. Verifique seus dados e tente novamente.'));
        case 'Email not confirmed':
          return Left(AppError('Por favor, confirme seu e-mail antes de fazer login.'));
        case 'Too many requests':
          return Left(AppError('Muitas tentativas de login. Aguarde alguns minutos e tente novamente.'));
        default:
          return Left(AppError('Não foi possível fazer login no momento. Tente novamente.'));
      }
    } catch (e) {
      return Left(AppError('Erro de conexão. Verifique sua internet e tente novamente.'));
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
  Future<Either<AppError, AuthResponse>> signUp({
    required String email,
    required String password,
    required String username,
    required String avatarUrl,
  }) async {
    try {
      print('🚀 AuthService: Iniciando cadastro para $email');
      
      // Verificar se o username está disponível
      final existingUsername = await _supabaseClient
          .from('profiles')
          .select()
          .eq('username', username)
          .maybeSingle();

      if (existingUsername != null) {
        print('❌ Username não disponível: $username');
        return Left(AppError('Username não disponível'));
      }

      print('✅ Username disponível! Criando usuário 🤩');
      final result = await insertUser(email: email, password: password);
      
      return result.fold(
        (left) => Left(left), 
        (right) async {
          print('✅ Usuário criado. Inserindo profile ');
          try {
            await _supabaseClient.from('profiles').insert({
              'id': right.user!.id,
              'username': username,
              'avatar_url': avatarUrl,
            });
            print('✅ Profile inserido com sucesso!');
            return Right(right);
          } catch (e) {
            print('❌ Erro ao inserir profile: $e');
            return Left(AppError('Erro ao criar perfil do usuário', e));
          }
        }
      );
    } on PostgrestException catch (e) {
      print('❌ PostgrestException: ${e.code} - ${e.message}');
      switch(e.code) {
        case '23505':
          return Left(AppError('E-mail já registrado'));
        default:
          return Left(AppError('Erro na autenticação. Verifique seus dados e tente novamente.'));
      }
    } catch (e) {
      print('❌ Erro inesperado: $e');
      return Left(AppError('Ops! Algo deu errado. Tente novamente em alguns instantes.'));
    }
  }

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
            AppError('E-mail não confirmado. Verifique sua caixa de entrada'),
          );
        default:
          return Left(AppError('Erro ao fazer cadastro', e));
      }
    }
  }

  Future<Either<AppError, void>> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      return Right(null);
    } on AuthException catch (e) {
      return Left(AppError('Erro ao sair', e));
    } catch (e) {
      return Left(AppError('Erro inesperado ao sair', e));
    }
  } // signOut
} // class AuthService