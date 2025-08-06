import 'package:app4_receitas/data/service/recipe_service.dart';
import 'package:app4_receitas/data/services/recipe_service.dart';	
import 'package:app4_receitas/di/service_locator.dart';

class RecipeRepository {
  final _service = getIt<RecipeService>();

  Future<List<Recipe>> getRecipes() async {
    try {
      final rawData = await _service.fetchRecipes();
      return rawData.map((data) => Recipe.fromJson(recipe)).toList();
    } catch (e) {
      throw Exception('Failed to fetch recipes: $e');
    }
  }
}