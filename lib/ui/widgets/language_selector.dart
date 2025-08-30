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
                Container(
                  width: 32,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.green.shade700),
                  ),
                  child: Center(
                    child: Text(
                      'BR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    LocalizationService.languageNames['pt']!,
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
                Container(
                  width: 32,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue.shade700),
                  ),
                  child: Center(
                    child: Text(
                      'US',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    LocalizationService.languageNames['en']!,
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
