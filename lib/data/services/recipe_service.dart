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

  Future<Map<String, dynamic>?> fetchRecipeById(String id) async {
    return await _supabaseClient.from('recipes').select().eq('id', id).single();
  }

  Future<List<Map<String, dynamic>>> fetchFavRecipes(String userId) async {
    return await _supabaseClient
      .from('favorites')
      .select('''
        recipes(
          id,
          name,
          ingredients,
          instructions,
          prep_time_minutes,
          cook_time_minutes,
          servings,
          difficulty,
          cuisine,
          calories_per_serving,
          tags,
          user_id,
          image,
          rating,
          review_count,
          meal_type
        )
      ''')
      .eq('user_id', userId);
  }

  Future<void> insertFavRecipe(String recipeId, String userId) async {
    await _supabaseClient.from('favorites').insert({
      'recipe_id': recipeId,
      'user_id': userId,
    });
  }

  Future<void> deleteFavRecipe(String recipeId, String userId) async {
    await _supabaseClient
        .from('favorites')
        .delete()
        .eq('recipe_id', recipeId)
        .eq('user_id', userId);
  }
}