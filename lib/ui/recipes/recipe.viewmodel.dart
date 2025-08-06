import 'package:app4_receitas/data/repositories/recipe_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:get/get.dart';

class recipesViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();
  
  final RxList<Recipe> _recipes = <Recipe>[].obs;
  final RxBool _isLoading = false.obs; 
  final RxString _errorMessage = ''.obs;

  // Getters
  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

 Future<void> getLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> getRecipes() async {
    try {
    }
  }
}