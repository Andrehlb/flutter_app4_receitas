// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Eu Amo Cozinhar';

  @override
  String get login => 'Login';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get register => 'Cadastre-se';

  @override
  String get home => 'Início';

  @override
  String get recipes => 'Receitas';

  @override
  String get favorites => 'Favoritas';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get english => 'English';

  @override
  String get portuguese => 'Português';

  @override
  String get logout => 'Sair';

  @override
  String get loginError => 'Erro no login. Verifique suas credenciais.';

  @override
  String get networkError => 'Erro de rede. Verifique sua conexão.';

  @override
  String get genericError => 'Ocorreu um erro inesperado.';
}
