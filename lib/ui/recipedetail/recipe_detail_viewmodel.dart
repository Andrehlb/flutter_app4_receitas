import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class RecipeDetailViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  /// A tela acessa `viewModel.recipe`
  Map<String, dynamic>? recipe;

  bool isFavorite = false;

  /// A tela chama `viewModel.loadRecipe(widget.id)`
  Future<void> loadRecipe(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // TODO: trocar por chamada real ao seu Repository/Service
      // Mock mínimo só para compilar e a tela renderizar.
      await Future.delayed(const Duration(milliseconds: 300));
      recipe = {
        'id': id,
        'name': 'Receita $id',
        'ingredients': 'Ingredientes...',
        'instructions': 'Instruções...',
      };
    } catch (e) {
      errorMessage = 'Falha ao carregar receita';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// A tela chama `viewModel.toggleFavorite()`
  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
