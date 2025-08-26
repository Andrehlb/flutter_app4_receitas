import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:app4_receitas/data/repositories/auth_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final _repository = getIt<AuthRepository>();
  final user = Rxn<UserProfile>();

  Future<void> loadUser() async {
    final result = await _repository.currentUser;
    result.fold((left) => null, (right) => user.value = right);
  }
}