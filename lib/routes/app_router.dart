import 'package:app4_receitas/data/services/auth_service.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/ui/auth/auth_view.dart';
import 'package:app4_receitas/ui/base_screen.dart';
import 'package:app4_receitas/ui/fav_recipes/fav_recipes_view.dart';
import 'package:app4_receitas/ui/profile/profile_view.dart';
import 'package:app4_receitas/ui/recipedetail/recipe_detail_view.dart';
import 'package:app4_receitas/ui/recipes/recipes_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter router;

  final _service = getIt<AuthService>();

  late final ValueNotifier<bool> _authStateNotifier;

  AppRouter() {

      _authStateNotifier = ValueNotifier<bool>(_service.currentUser != null);

    _service.authStateChanges.listen((state) async {
      _authStateNotifier.value = _service.currentUser != null;
    });

    router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _authStateNotifier,