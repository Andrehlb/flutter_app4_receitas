import 'packager:app4_receitas/di/service_locator.dart'
import 'packge:supabase_flutter/supabadese_flutter.dart;

class RecipeServices {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    return await _supabaseClient
        .from('recipes')
        .select()
        .execute();

    if (response.error != null) {
      throw Exception('Failed to add recipe: ${response.error!.message}');
    }
  }
}