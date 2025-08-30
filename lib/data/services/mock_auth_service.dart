import 'package:app4_receitas/utils/app_error.dart';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 🎭 MOCK AuthService para demonstração quando Supabase não está disponível
class MockAuthService {
  // Mock users storage
  static final Map<String, Map<String, dynamic>> _mockUsers = {};
  static User? _currentUser;
  
  // Stream controller para simular auth state changes
  static final _authController = Stream<AuthState>.periodic(
    Duration(milliseconds: 100),
    (count) => AuthState(AuthChangeEvent.signedIn, null),
  );

  User? get currentUser => _currentUser;
  Stream<AuthState> get authStateChanges => _authController;

  Future<Either<AppError, AuthResponse>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simula delay de rede
    
    if (_mockUsers.containsKey(email)) {
      final userData = _mockUsers[email]!;
      if (userData['password'] == password) {
        _currentUser = User(
          id: userData['id'],
          email: email,
          createdAt: DateTime.now().toIso8601String(),
          appMetadata: {},
          userMetadata: {},
          aud: '',
        );
        
        return Right(AuthResponse(
          user: _currentUser,
          session: null,
        ));
      }
    }
    
    return Left(AppError('Credenciais inválidas'));
  }

  Future<Either<AppError, AuthResponse>> signUp({
    required String email,
    required String password,
    required String username,
    required String avatarUrl,
  }) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simula delay de rede
    
    if (_mockUsers.containsKey(email)) {
      return Left(AppError('E-mail já registrado'));
    }
    
    final userId = 'mock_${DateTime.now().millisecondsSinceEpoch}';
    
    _mockUsers[email] = {
      'id': userId,
      'password': password,
      'username': username,
      'avatar_url': avatarUrl,
    };
    
    _currentUser = User(
      id: userId,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
      appMetadata: {},
      userMetadata: {},
      aud: '',
    );
    
    return Right(AuthResponse(
      user: _currentUser,
      session: null,
    ));
  }

  Future<Either<AppError, Map<String, dynamic>?>> fetchUserProfile(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    
    // Busca pelo userId nos mock users
    for (var userData in _mockUsers.values) {
      if (userData['id'] == userId) {
        return Right({
          'id': userData['id'],
          'username': userData['username'],
          'avatar_url': userData['avatar_url'],
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }
    
    return Right({
      'id': userId,
      'username': 'Mock User',
      'avatar_url': '',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<Either<AppError, void>> signOut() async {
    await Future.delayed(Duration(milliseconds: 200));
    _currentUser = null;
    return Right(null);
  }
}
