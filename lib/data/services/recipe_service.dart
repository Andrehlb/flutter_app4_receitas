import 'package:app4_receitas/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  Future<List<Map<String, dynamic>>> fetchRecipes() async { // Método para buscar todas as receitas
    return await _supabaseClient // Chama o Supabase para buscar receitas
        .from('recipes')
        .select()
        .order('id', ascending: true);
  }

  Future<Map<String, dynamic>?> fetchRecipeById(String id) async { // Método para buscar 1 receita por id (UUID)
    return await _supabaseClient.from('recipes').select().eq('id', id).single();
  }

  Future<List<Map<String, dynamic>>> fetchFavRecipes(String userId) async {   // Retorna receitas favoritas do usuário AUTENTICADO (RLS)
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

  // Insere favorito (usa usuário autenticado por causa do RLS)
  Future<void> insertFavRecipe(String recipeId, String userId) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado. Faça login para favoritar.');
    }
    final uid = currentUser.id;

    final existing = await _supabaseClient
        .from('favorites')
        .select('recipe_id')
        .eq('user_id', uid)
        .eq('recipe_id', recipeId)
        .maybeSingle();

    if (existing != null) return;

    await _supabaseClient.from('favorites').insert({
      'user_id': uid,
      'recipe_id': recipeId,
    });
  }

  // Remove favorito (do usuário autenticado)
  Future<void> deleteFavRecipe(String recipeId, String userId) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado. Faça login para remover favorito.');
    }
    final uid = currentUser.id;

    await _supabaseClient
        .from('favorites')
        .delete()
        .eq('user_id', uid)
        .eq('recipe_id', recipeId);
  }
}