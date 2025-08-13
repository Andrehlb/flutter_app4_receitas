import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/ui/recipedetail/recipe_detail_viewmodel.dart';
import 'package:app4_receitas/ui/widgets/recipe_row_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailView extends StatefulWidget {
  const RecipeDetailView({super.key, required this.id});

  final String id;

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  final viewModel = getIt<RecipeDetailViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadRecipe(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading) {
        return Center(
          child: SizedBox(
            height: 96,
            width: 96,
            child: CircularProgressIndicator(strokeWidth: 12),
          ),
        );
      }

      if (viewModel.errorMessage! != '') {
        return Center(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              spacing: 32,
              children: [
                Text(
                  'Erro: ${viewModel.errorMessage}',
                  style: TextStyle(fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: Text('VOLTAR'),
                ),
              ],
            ),
          ),
        );
      }

      final recipe = viewModel.recipe;
      return SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              recipe!.image!,
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                  ? child
                  : Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
              errorBuilder: (context, child, stackTrace) => Container(
                height: 400,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    recipe.name,
                    style: GoogleFonts.dancingScript(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  RecipeRowDetails(recipe: recipe),
                  const SizedBox(height: 16),
                  recipe.ingredients.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Ingredientes:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(recipe.ingredients.join('\n')),
                          ],
                        )
                      : Text('Nenhum ingrediente listado.'),
                  const SizedBox(height: 16),
                  recipe.instructions.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Instruções:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(recipe.instructions.join('\n')),
                          ],
                        )
                      : Text('Nenhuma instrução :('),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/'),
                        child: Text('VOLTAR'),
                      ),
                      ElevatedButton(
                        onPressed: () => viewModel.toggleFavorite(),
                        child: Text(
                          viewModel.isFavorite ? 'DESFAVORITAR' : 'FAVORITAR',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}