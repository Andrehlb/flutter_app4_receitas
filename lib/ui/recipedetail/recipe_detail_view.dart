import 'package:flutter/widgets.dart';

class RecipeDetailView extends StatefulWidget {
  const RecipeDetailView(super.key, {required this.id});

  final String id;

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}