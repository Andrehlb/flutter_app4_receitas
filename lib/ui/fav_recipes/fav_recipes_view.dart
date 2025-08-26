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

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    _userId = user?.id;

    if (_userId != null) {
      vm.loadFavorites(_userId!);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Login necessário', 'Faça login para ver seus favoritos.');
      });
    }
  }

  Future<void> _refresh() async {
    if (_userId != null) {
      await vm.loadFavorites(_userId!);
    }
  }

  Future<void> _remove(Recipe r) async {
    if (_userId == null) return;
    await vm.removeFavorite(_userId!, r.id);
    if (mounted) {
      Get.snackbar('Favoritos', 'Removido de favoritos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas favoritas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                _userId == null ? null : () => vm.loadFavorites(_userId!),
            tooltip: 'Atualizar favoritos',
          ),
        ],
      ),
      body: Obx(() {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = vm.errorMessage;
        if (error != null && error.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(error, textAlign: TextAlign.center),
            ),
          );
        }

        if (_userId == null) {
          return const Center(
            child: Text('Faça login para ver seus favoritos.'),
          );
        }

        final items = vm.favRecipes;
        if (items.isEmpty) {
          return const Center(
            child: Text('Você ainda não tem receitas favoritas.'),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final r = items[index];
              return ListTile(
                leading: _RecipeAvatar(imageUrl: r.image, fallbackText: r.name),
                title: Text(r.name),
                subtitle: Text(_buildSubtitle(r)),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  tooltip: 'Remover dos favoritos',
                  onPressed: () => _remove(r),
                ),
                onTap: () {
                  // TODO: navegar para tela de detalhes, se existir
                },
              );
            },
          ),
        );
      }),
    );
  }

  String _buildSubtitle(Recipe r) {
    final parts = <String>[];
    if (r.difficulty != null && r.difficulty!.isNotEmpty) {
      parts.add(r.difficulty!);
    }
    final total = r.totalTimeMinutes;
    if (total > 0) parts.add('$total min');
    if (r.cuisine != null && r.cuisine!.isNotEmpty) parts.add(r.cuisine!);
    return parts.join(' • ');
  }
}

class _RecipeAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fallbackText;
  const _RecipeAvatar({required this.imageUrl, required this.fallbackText});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      return CircleAvatar(backgroundImage: NetworkImage(imageUrl!));
    }
    return CircleAvatar(
      child: Text(fallbackText.isNotEmpty ? fallbackText[0] : '?'),
    );
  }
}