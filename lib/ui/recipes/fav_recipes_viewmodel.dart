import 'package:get/get.dart';
import 'package:app4_receitas/data/models/recipe.dart';
import 'package:app4_receitas/data/repositories/recipe_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';

class FavRecipesViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();

