import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
 final getIt = GetIt.instance;

 Future<void> setupServiceLocator() async {
  // Supabase Cleint
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
   // Register your services and controllers here
   // Example:
  getIt.registerLazySingleton<RecipeService>(() => RecipeService());
   // getIt.registerFactory<YourController>(() => YourController(getIt<YourService>()));
 }

   // Recipe Repository
 getIt.registerLazySingleton<RecipeRepository>(() => RecipeRepository());