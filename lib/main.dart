import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app4_receitas/di/service_locator.dart'; // Mantém o setUpDependencies()
import 'package:app4_receitas/routes/app_router.dart';
import 'package:app4_receitas/utils/config/env.dart';
import 'package:app4_receitas/utils/theme/custom_theme_controller.dart';
// DIFERENÇA 1: Service com persistência ao invés de LocaleController simples
import 'package:app4_receitas/services/localization_service.dart';
// DIFERENÇA 2: Import da pasta generated/ (reorganização da estrutura) ao invés de app_localizations.dart direto
import 'package:app4_receitas/l10n/generated/app_localizations.dart';

Future<void> main() async {
  // Garante que o Flutter está inicializado
/*  WidgetsFlutterBinding.ensureInitialized();

  // carregar variáveis de ambiente
  //await Env.init();

  // Inicializar o Supabase
  //await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey,);
  await Supabase.initialize(
    url: 'https://juribdadppycdlovoyxe.supabase.co', // SUA URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1cmliZGFkcHB5Y2Rsb3ZveXhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0MzE2ODcsImV4cCI6MjA3MDAwNzY4N30.-ayR36OhOhjJbSc7BUI3b_L6OTYeDorgPxjXo-aTKs4', // SUA ANON PUBLIC KEY
    debug: true, // log detalhado no console
  );
*/
    WidgetsFlutterBinding.ensureInitialized();
await Env.init(); // <- precisa vir antes do initialize

await Supabase.initialize(
  url: Env.supabaseUrl,
  anonKey: Env.supabaseAnonKey,
);

  // Inicializando as dependências
  await setupDependencies();

  // DIFERENÇA 3: Inicialização do service no main() para garantir disponibilidade global
  // Versão original: Get.put(LocaleController()) no build()
  Get.put(LocalizationService());

  runApp(const AndrehlbApp());
  // runnApp(const MyApp());
}

// DIFERENÇA 4: Nome da classe app personalizado (AndrehlbApp) ao invés de MainApp genérico
class AndrehlbApp extends StatelessWidget {
  const AndrehlbApp({super.key});

  @override
  Widget build(BuildContext context) {

    // * Get.put
    // Usado para injetar dependências no GetX
    final theme = Get.put(CustomThemeController());
    // DIFERENÇA 5: Busca o service já inicializado ao invés de criar novo controller
    // Versão original: final localeController = Get.put(LocaleController());
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
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // DIFERENÇA 6: Lista dinâmica de locales ao invés de hardcoded
        // Versão original: supportedLocales: [Locale('en'), Locale('pt', 'BR')]
        supportedLocales: LocalizationService.supportedLocales,
        // DIFERENÇA 7: Locale com persistência automática ao invés de apenas em memória
        // Versão original: locale: localeController.locale (sem persistência)
        locale: localizationService.currentLocale,
        
        routerConfig: AppRouter().router,
      ),
    );
  }
}

/*
RESUMO DAS PRINCIPAIS DIFERENÇAS EM RELAÇÃO À VERSÃO ORIGINAL:

1. ✅ Service avançado: LocalizationService vs LocaleController simples
2. ✅ Estrutura organizada: Import da pasta generated/ ao invés de direta
3. ✅ Inicialização no main(): Service disponível globalmente desde o início
4. ✅ Nome personalizado: AndrehlbApp ao invés de MainApp genérico  
5. ✅ Service injetado: Get.find<>() ao invés de Get.put() no build()
6. ✅ Locales dinâmicos: Lista configurável ao invés de hardcoded
7. ✅ Persistência automática: SharedPreferences vs apenas memória

BENEFÍCIOS IMPLEMENTADOS:
- 💾 App "lembra" do idioma escolhido entre sessões
- 🏗️ Concentração da lógica de negócio num lugar só
- 🔧 Maior flexibilidade para adicionar novos idiomas
- 🧪 Teste com mock único
- 📱 UX melhorada - configuração persiste
*/