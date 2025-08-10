import 'package:get/get.dart';
import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/repositories/recipe_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';

class FavRecipesViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();

  final RxList<Recipe> _favRecipes = <Recipe>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  List<Recipe> get favRecipes => _favRecipes;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  Future<void> loadFavorites(String userId) async {
    try {
      _isLoading.value = true;
      // Busca favoritos do usuário pelo ID do usuário
      // Atualiza a lista de favoritos com os dados recebidos
      _favRecipes.value = await _repository.getFavorites(userId);
    } catch (e) {
      _errorMessage.value = 'Algo deu errado ao carregar favoritos: $e, aguarde por favor.';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addFavorite(String userId, Recipe recipe) async {
    try {
      await _repository.addFavorite(recipe.id, userId);
      if (!_favRecipes.any((r) => r.id == recipe.id)) {
        _favRecipes.add(recipe);
      }
    } catch (e) {
      _errorMessage.value = 'Não foi possível adicionar aos favoritos: $e. Tente novamente mais tarde.';
    }
  }
}