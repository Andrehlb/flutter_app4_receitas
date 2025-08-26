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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
        return Stack(
          children: [
            SingleChildScrollView(
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
                            Obx(() {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: ElevatedButton(
                                  key: ValueKey<bool>(viewModel.isFavorite),
                                  onPressed: () {
                                    viewModel.toggleFavorite();
                                    _animationController.forward();
                                  },
                                  child: Text(
                                    viewModel.isFavorite
                                        ? 'DESFAVORITAR'
                                        : 'FAVORITAR',
                                  ),
                                ),
                              );
                            }),
                          