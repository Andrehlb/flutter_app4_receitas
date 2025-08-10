import 'package:app4_receitas/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    return await _supabaseClient
        .from('recipes')
        .select()
        .order('id', ascending: true);
  }

  Future<void> addFavorite(String recipeId, String userId) async {
    final response = await _supabaseClient
        .from('favorites')
        .insert({'recipe_id': recipeId, 'user_id': userId});

    if (response.error != null) {
      throw Exception('A tentativa de marcar a recieta: ${response.error!.message}, como favorita falhou. 😕 <br> Tente novamente mais tarde.');
    }
  }

  Future<void> removeFavorite(String recipeId, String userId) async {
    final response = await _supabaseClient
        .from('favorites')
        .delete()
        .match({'recipe_id': recipeId, 'user_id': userId});

    if (response.error != null) {
      throw Exception('Falhou a tentativa de remover de favoritos a receita: ${response.error!.message} 😕 <br> Tente novamente mais tarde.');
    }
  }
}