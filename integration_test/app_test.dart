import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app4_receitas/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Auth E2E Test', () {
    testWidgets('deve inicializar app e mostrar elementos', (tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 10)); // Aguarda mais tempo
      
      // Debug: vamos ver o que está na tela
      print('🔍 Procurando elementos na tela...');
      
      // Busca elementos mais genéricos primeiro
      final scaffolds = find.byType(Scaffold);
      final materialApps = find.byType(MaterialApp);
      
      print('📱 Scaffolds encontrados: ${scaffolds.evaluate().length}');
      print('📱 MaterialApps encontrados: ${materialApps.evaluate().length}');
      
      // Tenta encontrar qualquer texto na tela
      expect(materialApps, findsAtLeastNWidgets(1));
      
      print('✅ App inicializou com sucesso!');
    });
  });
}
