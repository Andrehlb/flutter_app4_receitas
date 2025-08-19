import 'package:flutter/material.dart';

class RecipeRowDetails extends StatelessWidget {
  final String ingredient;

  const RecipeRowDetails({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Text(ingredient);
  }
}
