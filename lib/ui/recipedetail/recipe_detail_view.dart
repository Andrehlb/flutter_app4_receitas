import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/ui/recipes/recipes_viewmodel.dart';
import 'package:app4_receitas/ui/widgets/recipe_card.dart';
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

  class _RecipeDetailViewState extends State<RecipeDetailView>
    with SingleTickerProviderStateMixin {
  final viewModel = getIt<RecipeDetailViewModel>();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.bounceInOut)
          ..addListener(() => setState(() {}))
          ..addStatusListener((listener) {
            if (listener == AnimationStatus.completed) {
              _animationController.reverse();
            }
          });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadRecipe(widget.id);
    });
  }

      if (viewModel.errorMessage != '') {
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
                    viewModel.getRecipes();
                  },
                  child: Text('TENTAR NOVAMENTE'),
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child:
              viewModel.recipes.isNotEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Text(
                            '${viewModel.recipes.length} receitas(s)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = viewModel.recipes[index];
                                // final isFavorite = viewModel.favRecipes.any(
                                //   (fav) => fav.id == recipe.id,
                                // );
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          context.go('/recipe/${recipe.id}'),
                                      child: RecipeCard(recipe: recipe),
                                    ),
                                    // Positioned(
                                    //   top: 16,
                                    //   right: 16,
                                    //   child: IconButton(
                                    //     icon: Icon(
                                    //       isFavorite
                                    //           ? Icons.favorite
                                    //           : Icons.favorite_border,
                                    //       size: 32,
                                    //       color: isFavorite ? Colors.red : null,
                                    //     ),
                                    //     onPressed: () {
                                    //       if (isFavorite) {
                                    //         viewModel.removeFromFavorites(
                                    //           recipe,
                                    //         );
                                    //         if (context.mounted) {
                                    //           ScaffoldMessenger.of(
                                    //             context,
                                    //           ).clearSnackBars();
                                    //           ScaffoldMessenger.of(
                                    //             context,
                                    //           ).showSnackBar(
                                    //             SnackBar(
                                    //               content: Text(
                                    //                 '${recipe.name} desfavoritada!',
                                    //               ),
                                    //               duration: Duration(
                                    //                 seconds: 3,
                                    //               ),
                                    //               action: SnackBarAction(
                                    //                 label: 'DESFAZER',
                                    //                 onPressed: () {
                                    //                   viewModel.addToFavorites(
                                    //                     recipe,
                                    //                   );
                                    //                 },
                                    //               ),
                                    //             ),
                                    //           );
                                    //         }
                                    //       } else {
                                    //         viewModel.addToFavorites(recipe);
                                    //         if (context.mounted) {
                                    //           ScaffoldMessenger.of(
                                    //             context,
                                    //           ).clearSnackBars();
                                    //           ScaffoldMessenger.of(
                                    //             context,
                                    //           ).showSnackBar(
                                    //             SnackBar(
                                    //               content: Text(
                                    //                 '${recipe.name} favoritada!',
                                    //               ),
                                    //               duration: const Duration(
                                    //                 seconds: 2,
                                    //               ),
                                    //             ),
                                    //           );
                                    //         }
                                    //       }
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  :
                  Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 64),
                          Icon(
                            Icons.favorite,
                            size: 96,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Adicione suas receitas favoritas!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}