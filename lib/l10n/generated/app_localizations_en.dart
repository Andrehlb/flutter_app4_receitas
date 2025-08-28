// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Eu Amo Cozinhar';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Enter';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get register => 'Register';

  @override
  String get home => 'Home';

  @override
  String get recipes => 'Recipes';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get portuguese => 'Português';

  @override
  String get logout => 'Logout';

  @override
  String get loginError => 'Login error. Please check your credentials.';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get genericError => 'An unexpected error occurred.';
}
