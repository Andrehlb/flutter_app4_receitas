// lib/utils/config/env.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static bool _loaded = false;

  /// Carrega o .env de assets/.env e valida as variáveis obrigatórias.
  static Future<void> init() async {
    if (_loaded) return;

    // 1) Carregar o arquivo
    await dotenv.load(fileName: 'assets/.env');

    // 2) Ler variáveis (com fallback para --dart-define, se você usar em CI)
    final url = dotenv.env['SUPABASE_URL'] ??
        const String.fromEnvironment('SUPABASE_URL');
    final anon = dotenv.env['SUPABASE_ANON_KEY'] ??
        const String.fromEnvironment('SUPABASE_ANON_KEY');

    // 3) Sanitizar (evita espaços/quebras vindas de copiar/colar)
    final supabaseUrl = url.trim();
    final supabaseAnonKey = anon.trim();

    // 4) Validar (erros claros para você no console)
    if (supabaseUrl.isEmpty || !supabaseUrl.startsWith('https://')) {
      throw StateError(
        'SUPABASE_URL inválida ou vazia. Verifique assets/.env (SUPABASE_URL=...)',
      );
    }
    if (supabaseAnonKey.isEmpty || supabaseAnonKey.length < 100) {
      throw StateError(
        'SUPABASE_ANON_KEY inválida ou vazia. Verifique assets/.env (cole a chave COMPLETA).',
      );
    }

    // 5) Log útil em debug (não imprime a chave inteira)
    if (kDebugMode) {
      final masked = '${supabaseAnonKey.substring(0, 12)}...'
          '${supabaseAnonKey.substring(supabaseAnonKey.length - 6)}';
      // ignore: avoid_print
      print('[Env] .env carregado ✓  URL=$supabaseUrl  ANON=$masked');
    }

    // 6) Guardar em campos estáticos
    _supabaseUrl = supabaseUrl;
    _supabaseAnonKey = supabaseAnonKey;
    _loaded = true;
  }

  static late final String _supabaseUrl;
  static late final String _supabaseAnonKey;

  static String get supabaseUrl {
    assert(_loaded, 'Env.init() precisa ser chamado antes de ler supabaseUrl');
    return _supabaseUrl;
  }

  static String get supabaseAnonKey {
    assert(_loaded, 'Env.init() precisa ser chamado antes de ler supabaseAnonKey');
    return _supabaseAnonKey;
  }
}
