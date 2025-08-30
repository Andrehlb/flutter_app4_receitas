import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/localization_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language), // ✅ GLOBO DE VOLTA!
      tooltip: 'Selecionar Idioma',
      onSelected: (String languageCode) {
        localizationService.changeLanguage(languageCode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'pt',
          child: Row(
            children: [
              Text('🇧🇷', style: TextStyle(fontSize: 24)), // ✅ BANDEIRA BRASIL
              const SizedBox(width: 12),
              const Text('Português', style: TextStyle(fontSize: 16)),
              if (localizationService.currentLanguage == 'pt') ...[
                const Spacer(),
                const Icon(Icons.check, color: Colors.green, size: 20),
              ],
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Text('🇺🇸', style: TextStyle(fontSize: 24)), // ✅ BANDEIRA EUA
              const SizedBox(width: 12),
              const Text('English', style: TextStyle(fontSize: 16)),
              if (localizationService.currentLanguage == 'en') ...[
                const Spacer(),
                const Icon(Icons.check, color: Colors.green, size: 20),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// Widget alternativo para usar em outros lugares
class FloatingLanguageSelector extends StatelessWidget {
  const FloatingLanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();
    
    return FloatingActionButton.small(
      onPressed: () {
        // Alterna entre pt e en
        String newLanguage = localizationService.currentLanguage == 'pt' ? 'en' : 'pt';
        localizationService.changeLanguage(newLanguage);
      },
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      child: Text(
        localizationService.currentLanguage == 'pt' ? '🇧🇷' : '🇺🇸',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
