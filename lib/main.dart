import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app4_receitas/di/service_locator.dart'; // Mantém o setUpDependencies()
import 'package:app4_receitas/routes/app_router.dart';
import 'package:app4_receitas/utils/config/env.dart';
import 'package:app4_receitas/utils/theme/custom_theme_controller.dart';
import 'package:app4_receitas/services/localization_service.dart';
import 'package:app4_receitas/l10n/generated/app_localizations.dart';

Future<void> main() async {
  // Garante que o Flutter está inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // carregar variáveis de ambiente
  await Env.init();

  // Inicializar o Supabase
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey,);

  // Inicializando as dependências
  await setupDependencies();

  // Inicializar serviço de localização
  Get.put(LocalizationService());

  runApp(const AndrehlbApp());
  // runnApp(const MyApp());
}

class AndrehlbApp extends StatelessWidget {
  const AndrehlbApp({super.key});

  @override
  Widget build(BuildContext context) {

    // * Get.put
    // Usado para injetar dependências no GetX
    final theme = Get.put(CustomThemeController());
    final localizationService = Get.find<LocalizationService>();

    // * Obx
    // Usado para tornar um widget reativo
    return Obx(
      () => MaterialApp.router(
        title: 'Eu Amo Cozinhar',
        debugShowCheckedModeBanner: false,
        theme: theme.customTheme,
        darkTheme: theme.customThemeDark,
        themeMode: theme.isDark.value ? ThemeMode.dark : ThemeMode.light,
        
        // Configuração de internacionalização
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LocalizationService.supportedLocales,
        locale: localizationService.currentLocale,
        
        routerConfig: AppRouter().router,
      ),
    );
  }
}