import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app4_receitas/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Auth E2E Test', () {
    testWidgets('deve mostrar tela de login', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Verifica se a tela de login carregou
      expect(find.text('Eu Amo Cozinhar'), findsOneWidget);
      expect(find.text('Entre na sua conta'), findsOneWidget);
      
      // Se você tem botão do GitHub, procure por ele
      // expect(find.text('Entrar com GitHub'), findsOneWidget);
      
      print('✅ Tela de login carregou com sucesso!');
    });
    
    testWidgets('deve preencher campos (sem enviar)', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      final emailField = find.byKey(ValueKey('emailField'));
      final passwordField = find.byKey(ValueKey('passwordField'));
      
      // Testa apenas o preenchimento, sem fazer login real
      await tester.enterText(emailField, 'teste@exemplo.com');
      await tester.enterText(passwordField, 'senha123');
      
      // Verifica se os campos foram preenchidos
      expect(find.text('teste@exemplo.com'), findsOneWidget);
      
      print('✅ Campos preenchidos com sucesso!');
    });
  });
}
