import 'package:app4_receitas/data/models/user_profile.dart';
import 'package:app4_receitas/data/repositories/auth_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProfileViewModel extends GetxController {
  final _repository = getIt<AuthRepository>();

  final _profile = Rxn<UserProfile>();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  Rxn<UserProfile> get profile => _profile;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  Future<void> getCurrentuser() async {
    _isLoading.value = true;
    final result = await _repository.currentUser;
    result.fold(
      (left) => _errorMessage.value = left.message,
      (right) => _profile.value = right,
    );
    _isLoading.value = false;
  }

  Future<void> signOut() async {
    _isLoading.value = true;
    final result = await _repository.signOut();
    result.fold((left) => _errorMessage.value = left.message, (right) {});
    _isLoading.value = false;
  }
}