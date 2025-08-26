import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:app4_receitas/ui/auth/auth_view.dart';
import 'package:app4_receitas/ui/auth/auth_viewmodel.dart';
import 'package:app4_receitas/data/repositories/auth_repository.dart';
import 'package:app4_receitas/data/services/auth_service.dart';

// ✅ Gera os mocks automaticamente
@GenerateMocks([AuthRepository, AuthService])
import 'auth_view_test.mocks.dart';

void main() {
  // Instância do GetIt para testes
  final getIt = GetIt.instance;
  
  // Mocks das dependências
  late MockAuthRepository mockAuthRepository;
  late MockAuthService mockAuthService;

  // setUp é executado ANTES de cada teste
  setUp(() {
    // Limpa todas as dependências registradas
    getIt.reset();
    
    // Cria os mocks das dependências
    mockAuthRepository = MockAuthRepository();
    mockAuthService = MockAuthService();
    
    // ✅ Registra os MOCKS das dependências (não o ViewModel real)
    getIt.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
    getIt.registerLazySingleton<AuthService>(() => mockAuthService);
    
    // ✅ Agora registra o ViewModel REAL (que vai usar os mocks)
    getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
  });

  // tearDown é executado DEPOIS de cada teste
  tearDown(() {
    // Limpa tudo para não interferir no próximo teste
    getIt.reset();
  });

  // Grupo de testes para AuthView
  group('AuthView', () {
    
    testWidgets('deve verificar o título', (WidgetTester tester) async {
      // Constrói a tela AuthView dentro de um MaterialApp
      await tester.pumpWidget(MaterialApp(home: AuthView()));
      
      // Aguarda todas as animações e rebuilds
      await tester.pumpAndSettle();

      // Procura pelo texto "Eu Amo Cozinhar" na tela
      final title = find.text('Eu Amo Cozinhar');
      
      // Verifica se encontrou exatamente 1 widget com esse texto
      expect(title, findsOneWidget);
    });

    testWidgets('deve verificar se campos de login existem', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AuthView()));
      await tester.pumpAndSettle();

      // Verifica se existe campo de e-mail
      final emailField = find.widgetWithText(TextFormField, 'E-mail');
      expect(emailField, findsOneWidget);

      // Verifica se existe campo de senha
      final passwordField = find.widgetWithText(TextFormField, 'Senha');
      expect(passwordField, findsOneWidget);
    });

    testWidgets('deve verificar se botão ENTRAR existe', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AuthView()));
      await tester.pumpAndSettle();

      // Verifica se existe botão com texto "ENTRAR"
      final loginButton = find.text('ENTRAR');
      expect(loginButton, findsOneWidget);
    });
  });
}
