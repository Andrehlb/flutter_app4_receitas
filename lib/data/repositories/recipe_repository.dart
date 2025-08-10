import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/services/recipe_service.dart';	
import 'package:app4_receitas/di/service_locator.dart';

class RecipeRepository {
  final _service = getIt<RecipeService>();
  
  Future<List<Recipe>> getRecipes() async {
    // print('getRecipes chamado!'); // Debug print statement
    try {
      final rawData = await _service.fetchRecipes();
      // print('Dados rawData recebidos: $rawData (${rawData.runtimeType})'); // Debug print statement
      return rawData.map((data) => Recipe.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Hum! Falhou ao buscar receitas 😬: ${e.toString()}');
    }
  }
}