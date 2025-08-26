import 'package:app4_receitas/utils/theme/custom_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final theme = Get.find<CustomThemeController>();

  int _currentIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        setState(() => _currentIndex = 0);
        GoRouter.of(context).go('/');
        break;
      case 1:
        setState(() => _currentIndex = 1);
        GoRouter.of(context).go('/favorites');
        break;
      case 2:
        setState(() => _currentIndex = 2);
        GoRouter.of(context).go('/profile');
        break;
      case 3:
        theme.toogleTheme();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      selectedItemColor: Theme.of(context).colorScheme.error,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Receitas',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritas'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        BottomNavigationBarItem(
          icon: Obx(() {
            return theme.isDark.value
                ? const Icon(Icons.nightlight_round_sharp, size: 24)
                : const Icon(Icons.wb_sunny_outlined, size: 24);
          }),
          label: 'Tema',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}