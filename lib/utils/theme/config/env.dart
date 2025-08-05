import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}