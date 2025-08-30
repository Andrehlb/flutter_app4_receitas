import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/localization_service.dart';
import '../../l10n/generated/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();
    
    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone do globo + bandeira do idioma atual
            Stack(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: localizationService.currentLanguage == 'pt' 
                        ? Colors.green 
                        : Colors.blue,
                    ),
                    child: Text(
                      localizationService.currentLanguage == 'pt' ? 'BR' : 'US',
                      style: TextStyle(
                        fontSize: 6,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          ],
        ),
      ),
      tooltip: AppLocalizations.of(context)?.selectLanguage ?? 'Selecionar Idioma',
      onSelected: (String languageCode) {
        localizationService.changeLanguage(languageCode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'pt',
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // ← BANDEIRA DO BRASIL: Solução personalizada, para dar certo, me deu trabalho!
                Container(
                  width: 32,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00A859), // Verde vibrante
                        Color(0xFF007B3F), // Verde mais escuro
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Losango dourado com gradiente
                      Center(
                        child: Transform.rotate(
                          angle: 0.785398,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFFFFD700), // Dourado brilhante
                                  Color(0xFFFFA500), // Dourado escuro
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Círculo azul premium
                      Center(
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFF1E3A8A), // Azul royal
                                Color(0xFF1E1B4B), // Azul escuro
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${LocalizationService.languageNames['pt']!} (BR)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: localizationService.currentLanguage == 'pt' 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                    ),
                  ),
                ),
                if (localizationService.currentLanguage == 'pt')
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'en',
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // ← BANDEIRA EUA: deu o trabalho!
                Container(
                  width: 32,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        // Listras com gradientes suaves
                        Column(
                          children: List.generate(13, (index) {
                            return Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: index % 2 == 0 
                                      ? [Color(0xFFB22234), Color(0xFF8B1538)] // Vermelho
                                      : [Colors.white, Color(0xFFF5F5F5)],     // Branco
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        // Cantão azul premium
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF1E40AF), // Azul vibrante
                                  Color(0xFF1E3A8A), // Azul escuro
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${LocalizationService.languageNames['en']!} (US)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: localizationService.currentLanguage == 'en' 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                    ),
                  ),
                ),
                if (localizationService.currentLanguage == 'en')
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Widget alternativo - Botão flutuante mais visível
class FloatingLanguageSelector extends StatelessWidget {
  const FloatingLanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();
    
    return Obx(() {
      final currentFlag = localizationService.currentLanguage == 'pt' ? '🇧🇷' : '🇺🇸';
      
      return FloatingActionButton.small(
        heroTag: "language_selector",
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => _showLanguageDialog(context, localizationService),
        child: Text(
          currentFlag,
          style: const TextStyle(fontSize: 24),
        ),
      );
    });
  }
  
  void _showLanguageDialog(BuildContext context, LocalizationService service) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇧🇷', style: TextStyle(fontSize: 24)),
              title: Text(LocalizationService.languageNames['pt']!),
              trailing: service.currentLanguage == 'pt' 
                ? const Icon(Icons.check, color: Colors.green) 
                : null,
              onTap: () {
                service.changeLanguage('pt');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: Text(LocalizationService.languageNames['en']!),
              trailing: service.currentLanguage == 'en' 
                ? const Icon(Icons.check, color: Colors.green) 
                : null,
              onTap: () {
                service.changeLanguage('en');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
