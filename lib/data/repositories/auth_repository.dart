import 'package:get/get.dart';
import 'package:either_dart/either.dart';
import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:app4_receitas/data/services/auth_service.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/utils/app_error.dart';

class AuthRepository extends GetxController {
  final _service = getIt<AuthService>();

  // Vai retornar o UserProfile
  Future<Either<AppError, UserProfile>> get currentUser async {
    final user = _service.currentUser;
    final profile = await _service.fetchUserProfile(user!.id);
    return profile.fold(
      (left) => Left(left),
      (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
    );
  }

  Future<Either<AppError, UserProfile>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final result = await _service.signInWithPassword(
      email: email,
      password: password,
    );
    return result.fold((left) => Left(left),(right) async {
      final user = right.user!;
      final profileResult = await _service.fetchUserProfile(user.id);
      return profileResult.fold(
        (left) => Left(left),
        (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
      ); // profileResult
    }); // return.fold and async
  } // async form signInWithPassword

  Future<Either<AppError, UserProfile>> signUp({
    required String email,
    required String password,
    required String username,
    required String avatarUrl,
  }) async {
    final result = await _service.signUp(
      email: email,
      password: password,
      username: username,
      avatarUrl: avatarUrl,
    ); // _service.signUp
    return result.fold((left) => Left(left), (right) async {
      final user = right.user!;
      final profileResult = await _service.fetchUserProfile(user.id);
      return profileResult.fold(
        (left) => Left(left),
        (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
      ); // profileResult.fold
    }); // async from result.fold
  } // async signUp

  Future<Either<AppError, void>> signOut() async {
    final result = await _service.signOut();
    return result.fold((left) => Left(left), (right) => const Right(null));
  } // async signOut
} // Class
