import 'package:app4_receitas/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  // Lista todas as receitas
  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    final data = await _supabaseClient
        .from('recipes')
        .select()
        .order('id', ascending: true);
    return (data as List).cast<Map<String, dynamic>>();
  }

  // Busca 1 receita por id (UUID)
  Future<Map<String, dynamic>?> fetchRecipeById(String id) async {
    final row = await _supabaseClient
        .from('recipes')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (row == null) return null;
    return (row as Map).cast<String, dynamic>();
  }

  // Retorna receitas favoritas do usuário AUTENTICADO (RLS)
  Future<List<Map<String, dynamic>>> fetchFavRecipes(String userId) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado. Faça login para ver favoritos.');
    }
    final uid = currentUser.id;

    // 1) Busca IDs favoritos
    final favRows = await _supabaseClient
        .from('favorites')
        .select('recipe_id')
        .eq('user_id', uid);

    final favoriteIds = (favRows as List)
        .map((r) => r['recipe_id']?.toString())
        .where((id) => id != null && id.isNotEmpty)
        .cast<String>()
        .toList();

    if (favoriteIds.isEmpty) return <Map<String, dynamic>>[];

    // 2) Busca as receitas correspondentes
    final recipes = await _supabaseClient
        .from('recipes')
        .select()
        .filter('id', 'in', favoriteIds) // Filtra por IDs favoritos, Agora, as duas opções: .in('id', favoriteIds) ou .in_('id', favoriteIds) não funcionanram
        .order('id', ascending: true);

    return (recipes as List).cast<Map<String, dynamic>>();
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