import 'package:get/get.dart';
import 'package:either_dart/either.dart';
import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/repositories/auth_repository.dart';
import 'package:app4_receitas/data/repositories/recipe_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';

class FavRecipesViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();
  final _authRepository = getIt<AuthRepository>();
  
  final RxList<Recipe> _favRecipes = <Recipe>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  List<Recipe> get favRecipes => _favRecipes;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  // ========= Como feito pelo Guilherme (sem passar userId) =========
  String? get _currentUid => Supabase.instance.client.auth.currentUser?.id;

  // Busca favoritos pegando o userId do usuário autenticado (RLS)
  Future<void> getFavRecipes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final uid = _currentUid;
      if (uid == null || uid.isEmpty) {
        _errorMessage.value = 'Ops! Não te encontramos com estes dados. \nPor favor, faz o login de novo \npara ver as receitas favoritas.';
        _favRecipes.clear();
        return;
      }

      _favRecipes.value = await _repository.getFavRecipes(uid);
    } catch (e) {
      _errorMessage.value = 'Ops! Aconteceu uma falha ao buscar receitas: $e. Por favor, tente mais tarde.';
    } finally {
      _isLoading.value = false;
    }
  }

  // Adiciona favorito pegando o userId do usuário autenticado (RLS)
  Future<void> addFavoriteAuto(Recipe recipe) async {
    try {
      final uid = _currentUid;
      if (uid == null || uid.isEmpty) {
        _errorMessage.value = 'Ops! Não encontramos seus dados.\nFaz login novamde novo \npara adicionar receitas aos favoritos.';
        return;
      }

      await _repository.insertFavRecipe(recipe.id, uid);
      if (!_favRecipes.any((r) => r.id == recipe.id)) {
        _favRecipes.add(recipe);
      }
    } catch (e) {
      _errorMessage.value = 'Ops! Neste momento, Não foi possível adicionar a receita aos favoritos: $e';
    }
  }

  // Remove favorito pegando o userId do usuário autenticado (RLS)
  Future<void> removeFavoriteAuto(String recipeId) async {
    try {
      final uid = _currentUid;
      if (uid == null || uid.isEmpty) {
        _errorMessage.value = 'Ops! Neste momento, Não foi possível adicionar a receita aos favortos';
        return;
      }

      await _repository.deleteFavRecipe(recipeId, uid);
      _favRecipes.removeWhere((r) => r.id == recipeId);
    } catch (e) {
      _errorMessage.value = 'Ops! Neste momento, não foi possível remover a receita dos favoritos: $e';
    }
  }

  // ========= Compatibilidade com o que você já tinha =========
  Future<void> loadFavorites(String userId) async {
    try {
      _isLoading.value = true;
      _favRecipes.value = await _repository.getFavRecipes(userId);
    } catch (e) {
      _errorMessage.value =
          'Algo deu errado ao carregar favoritos: $e. Tente mais tarde, por favor.';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addFavorite(String userId, Recipe recipe) async {
    try {
      await _repository.insertFavRecipe(recipe.id, userId);
      if (!_favRecipes.any((r) => r.id == recipe.id)) {
        _favRecipes.add(recipe);
      }
    } catch (e) {
      _errorMessage.value =
          'Ops! Neste momento, não foi possível adicionar a receita aos favoritos: $e. Tente novamente mais tarde, por favor.';
    }
  }

  Future<void> removeFavorite(String userId, String recipeId) async {
    try {
      await _repository.deleteFavRecipe(recipeId, userId);
      _favRecipes.removeWhere((r) => r.id == recipeId);
    } catch (e) {
      _errorMessage.value =
          'Ops! Neste momento, não foi possível remover a receita dos favoritos: $e. Tente novamente mais tarde, por favor.';
    }
  }
}