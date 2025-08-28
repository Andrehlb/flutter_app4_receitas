import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends GetxService {
  static const String _languageKey = 'selected_language';
  
  final RxString _currentLanguage = 'pt'.obs;
  
  String get currentLanguage => _currentLanguage.value;
  Locale get currentLocale => Locale(_currentLanguage.value);
  
  // Idiomas suportados
  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ];
  
  static const Map<String, String> languageNames = {
    'pt': 'Português',
    'en': 'English',
  };
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey) ?? 'pt';
    _currentLanguage.value = savedLanguage;
  }
  
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != _currentLanguage.value) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      
      _currentLanguage.value = languageCode;
      
      // Atualiza o idioma no GetX
      Get.updateLocale(Locale(languageCode));
    }
  }
  
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
}
