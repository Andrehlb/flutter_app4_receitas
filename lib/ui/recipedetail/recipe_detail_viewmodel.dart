import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/repositories/auth_repository.dart';
import 'package:app4_receitas/data/repositories/recipe_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';

class RecipeDetailViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();
  final _authRepository = getIt<AuthRepository>();

  // Estados
  final Rxn<Recipe> _recipe = Rxn<Recipe>();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isFavorite = false.obs;

  // Getters
  Recipe? get recipe => _recipe.value;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get isFavorite => _isFavorite.value;

  Future<void> loadRecipe(String id) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _recipe.value = await _repository.getRecipeById(id);
      var userId = '';
      await _authRepository.currentUser.fold(
        (left) => _errorMessage.value = left.message,
        (right) => userId = right.id,
      );
      _isFavorite.value = await isRecipeFavorite(id, userId);
    } catch (e) {
      _errorMessage.value = 'Falha ao buscar receita: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> isRecipeFavorite(String recipeId, String userId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final favRecipes = await _repository.getFavRecipes(userId);
      return favRecipes.any((recipe) => recipe.id == recipeId);
    } catch (e) {
      _errorMessage.value = 'Falha ao buscar receita favorita: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
    return false;
  }

  Future<void> toggleFavorite() async {
    var userId = '';
      await _authRepository.currentUser.fold(
        (left) => _errorMessage.value = left.message,
        (right) => userId = right.id,
      );
    final recipeId = recipe!.id;

    if (_isFavorite.value) {
      await removeFromFavorites(recipeId, userId);
    } else {
      await addToFavorites(recipeId, userId);
    }
  }

  Future<void> addToFavorites(String recipeId, String userId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _repository.insertFavRecipe(recipeId, userId);
      _isFavorite.value = true;
    } catch (e) {
      _errorMessage.value =
          'Falha ao adicionar receita favorita: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> removeFromFavorites(String recipeId, String userId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _repository.deleteFavRecipe(recipeId, userId);
      _isFavorite.value = false;
    } catch (e) {
      _errorMessage.value =
          'Falha ao remover receita favorita: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }
}