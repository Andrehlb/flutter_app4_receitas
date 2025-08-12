import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/services/recipe_service.dart';

class RecipeRepository {
  final RecipeService _service = getIt<RecipeService>();

  Future<List<Recipe>> getRecipes() async {
    final raw = await _service.fetchRecipes();
    return raw.map((m) => Recipe.fromJson(m)).toList();
  }

  Future<Recipe?> getRecipeById(String id) async {
    final raw = await _service.fetchRecipeById(id);
    return raw != null ? Recipe.fromJson(raw) : null;
  }

  // Nomes iguais aos do professor
  Future<List<Recipe>> getFavRecipes(String userId) async {
    final rawList = await _service.fetchFavRecipes(userId);
    return rawList.map((m) => Recipe.fromJson(m)).toList();
  }

  Future<void> insertFavRecipe(String recipeId, String userId) async {
    await _service.insertFavRecipe(recipeId, userId);
  }

  Future<void> deleteFavRecipe(String recipeId, String userId) async {
    await _service.deleteFavRecipe(recipeId, userId);
  }
}