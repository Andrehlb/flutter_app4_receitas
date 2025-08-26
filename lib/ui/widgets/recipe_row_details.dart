import 'package:flutter/material.dart';
import 'package:app4_receitas/data/models/recipe.dart';
class RecipeRowDetails extends StatelessWidget {
  const RecipeRowDetails({
    super.key, 
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(
              Icons.help_outline_sharp,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              '${recipe.difficulty}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.watch_later_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              '${recipe.prepTimeMinutes} min',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.people_alt_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              '${recipe.servings}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.local_fire_department_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              '${recipe.caloriesPerServing} cal',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.star_border_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              '${recipe.rating?.toStringAsFixed(1) ?? 'N/A'} (${recipe.reviewCount ?? 0})',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}