import 'package:app4_receitas/data/services/auth_service.dart';
import 'package:app4_receitas/di/service_locator.dart';
// import 'package:app4_receitas/ui/auth/auth_view.dart';
import 'package:app4_receitas/ui/recipes/recipes_view.dart';
// import 'package:app4_receitas/ui/recipes/fav_recipes_view.dart';
// import 'package:app4_receitas/ui/recipedetail/recipe_detail_view.dart';
import 'package:app4_receitas/ui/base_screen.dart';

class AppRouter {
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter router;

      routes: [
        ShellRoute(
          builder: (context, state, child) => BaseScreen(child: child),
          routes: [
            GoRoute(path: '/', builder: (context, state) => RecipesView()),
          ],
        ),
      ],
    );
  }
}
