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
      icon: Icon(
        Icons.language,
        color: Theme.of(context).colorScheme.primary,
      ),
      tooltip: AppLocalizations.of(context)?.selectLanguage ?? 'Select Language',
      onSelected: (String languageCode) {
        localizationService.changeLanguage(languageCode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'pt',
          child: Row(
            children: [
              const Text('🇧🇷', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(LocalizationService.languageNames['pt']!),
              if (localizationService.currentLanguage == 'pt')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, color: Colors.green, size: 16),
                ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(LocalizationService.languageNames['en']!),
              if (localizationService.currentLanguage == 'en')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, color: Colors.green, size: 16),
                ),
            ],
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
