import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:app4_receitas/data/services/auth_service.dart';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthService _service = getIt<AuthService>();

  User? get currentUser => _service.currentUser;
  //bool get isLoggedIn => _service.isLoggedIn;
  bool get isEmailConfirmed => _service.isEmailConfirmed;

  Future<AuthResponse> signUpEmailPassword({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) {
    return _service.signUpEmailPassword(
      email: email,
      password: password,
      username: username,
      avatarUrl: avatarUrl,
    );
  }

  // Mantido
  //Future<AuthResponse> signInWithPassword({
  Future<Either<AppError, AuthResponse>> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _authService.signInWithPassword(email: email, password: password);
  }

  // Novo: login seguro com Either
  Future<Either<String, AuthResponse>> signInWithPasswordSafe({
    required String email,
    required String password,
  }) {
    return _service.signInWithPasswordSafe(email: email, password: password);
  }

  Future<void> signOut() => _service.signOut();

  Future<UserProfile?> getCurrentUserProfile() =>
      _service.getCurrentUserProfile();

  Future<UserProfile?> getProfileById(String uid) =>
      _service.getProfileById(uid);

  Future<void> upsertProfile(UserProfile profile) =>
      _service.upsertProfile(profile);
}