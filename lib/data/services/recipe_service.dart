import 'package:app4_receitas/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  // Lista todas as receitas da tabela 'recipes' (id = UUID no Supabase)
  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    final data = await _supabaseClient
        .from('recipes')
        .select()
        .order('id', ascending: true);
    return (data as List).cast<Map<String, dynamic>>();
  }

  // Busca as receitas favoritas do usuário autenticado
  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado. Faça login para ver favoritos.');
    }
    final uid = currentUser.id;

    // 1) Busca IDs favoritos (recipe_id) do usuário na tabela 'favorites'
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

    // 2) Busca as receitas correspondentes na tabela 'recipes'
    final recipes = await _supabaseClient
        .from('recipes')
        .select()
        .in_('id', favoriteIds)
        .order('id', ascending: true);

    return (recipes as List).cast<Map<String, dynamic>>();
  }

  // Adiciona uma receita aos favoritos do usuário autenticado
  Future<void> addFavorite(String recipeId, String userId) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado. Favor autenticar para adicionar favoritos.');
    }
    final uid = currentUser.id;

    // Evita duplicado (PK: user_id + recipe_id)
    final existing = await _supabaseClient
        .from('favorites')
        .select('recipe_id')
        .eq('user_id', uid)
        .eq('recipe_id', recipeId)
        .maybeSingle();

    if (existing != null) return;

    await _supabaseClient.from('favorites').insert({
      'user_id': uid,        // RLS: precisa ser o uid autenticado
      'recipe_id': recipeId,
    });
  }

  // Remove uma receita dos favoritos do usuário autenticado
  Future<void> removeFavorite(String recipeId, String userId) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado. Favor autenticar para remover favoritos.');
    }
    final uid = currentUser.id;

    await _supabaseClient
        .from('favorites')
        .delete()
        .eq('user_id', uid)
        .eq('recipe_id', recipeId);
  }
}