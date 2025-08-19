import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/routes/app_router.dart';
import 'package:app4_receitas/utils/config/env.dart';
import 'package:app4_receitas/utils/theme/custom_theme_controller.dart';
Future<void> main() async {
  // Garante que o Flutter está inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // carregar variáveis de ambiente
  await Env.init();

  // Inicializar o Supabase
  await Supabase.initialize(    
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  // Inicializando as dependências
  await setupDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    // * Get.put
    // Usado para injetar dependências no GetX
    final theme = Get.put(CustomThemeController());

    // * Obx
    // Usado para tornar um widget reativo
    return Obx(
      () => MaterialApp.router(
        title: 'Eu Amo Cozinhar',
        debugShowCheckedModeBanner: false,
        theme: theme.customTheme,
        darkTheme: theme.customThemeDark,
        themeMode: theme.isDark.value ? ThemeMode.dark : ThemeMode.light,
        routerConfig: AppRouter().router,
      ),
    );
  }
}