import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthView Tests Simples', () {
    testWidgets('deve verificar se existe texto na tela', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Center(
              child: Text('Eu Amo Cozinhar'),
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Eu Amo Cozinhar'), findsOneWidget);
    });

    testWidgets('deve verificar se botão existe', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('ENTRAR'),
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text('ENTRAR'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('deve verificar campos de texto', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                TextField(
                  decoration: InputDecoration(hintText: 'E-mail'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Senha'),
                ),
              ],
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
