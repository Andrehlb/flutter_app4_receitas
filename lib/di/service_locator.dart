import 'package:app4_receitas/data/repositories/recipe_repository.dart';
import 'package:app4_receitas/data/services/recipe_service.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app4_receitas/ui/recipes/recipes_viewmodel.dart';
import 'package:app4_receitas/data/services/auth_service.dart';
import 'package:app4_receitas/data/repositories/auth_repository.dart';
 
 final getIt = GetIt.instance;

  // Esta função no `main()`, sendo chamada antes do `runApp()` 
 Future<void> setupLocator() async {
  // Registra o AuthService
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  // Repositories (os que dependem dos services)
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt<AuthService>()));

  // Supabase Cleint
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
   // Register of services and controllers
   // Recipe Service
  getIt.registerLazySingleton<RecipeService>(() => RecipeService());
  

   // Recipe Repository
  // getIt.registerLazySingleton<RecipeRepository>(() => RecipeRepository(getIt<RecipeService>()));
 

  // Recipe ViewModel
  getIt.registerLazySingleton<RecipesViewModel>(() => RecipesViewModel());
}