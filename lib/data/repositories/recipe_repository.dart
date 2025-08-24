import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/services/recipe_service.dart';

class RecipeRepository {
  final RecipeService _service = getIt<RecipeService>();

  Future<List<Recipe>> getRecipes() async {
    try{
    final rawData = await _service.fetchRecipes();
    return rawData.map((data) => Recipe.fromJson(data)).toList(); // Map o raw para buscar receitas
    } catch (e) {
    throw Exception('Falhou ao carregar as receitas 😢😞: ${e.toString()}');
    }
  }

  Future<Recipe?> getRecipeById(String id) async {
    final rawData = await _service.fetchRecipeById(id); // Chama o serviço para buscar uma receita pelo ID
    return rawData != null ? Recipe.fromJson(rawData) : null; // Converte o dado raw em objeto Recipe (se não for null)
  }

  Future<List<Recipe>> getFavRecipes(String userId) async { // Nomes iguais aos do professor
    final rawData = await _service.fetchFavRecipes(userId); // Chama o serviço para buscar receitas favoritas
    return rawData
      .where((data) => data['recipes'] != null) // filtra receitas não nulas
      .map ((data) => Recipe.fromJson(data['recipes'] as Map<String, dynamic>)) // Converte cada dado em objeto Recipe
      .toList(); // Converte o Iterable em List
  } // Fim do método getFavRecipes

  Future<void> insertFavRecipe(String recipeId, String userId) async { // Método para inserir receita favorita
    await _service.insertFavRecipe(recipeId, userId); // Chama o serviço para inserir receita favorita
  } // Fim do método insertFavRecipe

  Future<void> deleteFavRecipe(String recipeId, String userId) async { // Método para deletar receita favorita
    await _service.deleteFavRecipe(recipeId, userId);
  } // Fim do método deleteFavRecipe
}