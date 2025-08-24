import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/services/recipe_service.dart';

class RecipeRepository {
  final RecipeService _service = getIt<RecipeService>();

  Future<List<Recipe>> getRecipes() async {
    try{
    final rawData = await _service.fetchRecipes();
    // Map o raw para buscar receitas
    return rawData.map((data) => Recipe.fromJson(data)).toList();
    } catch (e) {
    throw Exception('Falhou ao carregar as receitas 😢😞: ${e.toString()}');
    }
  }

  Future<Recipe?> getRecipeById(String id) async {
    final raw = await _service.fetchRecipeById(id);
    // Converte o dado raw em objeto Recipe (se não for null)
    return raw != null ? Recipe.fromJson(raw) : null;
  }

  // Nomes iguais aos do professor
  Future<List<Recipe>> getFavRecipes(String userId) async {
    final rawList = await _service.fetchFavRecipes(userId);
    // Converte/MAPEIA rawList em lista de objetos recipes.
    return rawList.map((m) => Recipe.fromJson(m)).toList();
  }

  Future<void> insertFavRecipe(String recipeId, String userId) async {
    await _service.insertFavRecipe(recipeId, userId);
  }

  Future<void> deleteFavRecipe(String recipeId, String userId) async {
    await _service.deleteFavRecipe(recipeId, userId);
  }
}