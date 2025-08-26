import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/ui/fav_recipes/fav_recipes_viewmodel.dart';
import 'package:app4_receitas/ui/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';

class FavRecipesView extends StatefulWidget {
  const FavRecipesView({super.key});

  @override
  State<FavRecipesView> createState() => _FavRecipesViewState();
}

class _FavRecipesViewState extends State<FavRecipesView>
    with SingleTickerProviderStateMixin {
  final viewModel = getIt<FavRecipesViewModel>();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween(begin: 0.0, end: 200.0).animate(_animationController);
    _animation.addListener(() => setState(() {}));

  WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getFavRecipes();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                    viewModel.getFavRecipes();
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
              child: viewModel.favRecipes.isNotEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Text(
                            '${viewModel.favRecipes.length} favorita(s)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 200 - _animation.value,
                              ),
                              child: ListView.builder(
                                itemCount: viewModel.favRecipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = viewModel.favRecipes[index];
                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            context.go('/recipe/${recipe.id}'),
                                        child: RecipeCard(recipe: recipe),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
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