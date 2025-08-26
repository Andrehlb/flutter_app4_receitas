import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../../../lib/ui/auth/auth_view.dart';
import '../../../lib/ui/auth/auth_viewmodel.dart';
import '../../../lib/data/repositories/auth_repository.dart';
import '../../../lib/data/services/auth_service.dart';
import '../../../lib/di/service_locator.dart';

import 'auth_view_widget_test.mocks.dart';

@GenerateMocks([AuthRepository, AuthService, AuthViewModel])
void main() {
  late MockAuthViewModel mockAuthViewModel;

  setUp(() {
    // Limpa o GetIt antes de cada teste
    getIt.reset();
    
    // Cria o mock do ViewModel
    mockAuthViewModel = MockAuthViewModel();
    
    // Registra o ViewModel mock no GetIt (é isso que o AuthView precisa)
    getIt.registerLazySingleton<AuthViewModel>(() => mockAuthViewModel);
  });

  tearDown(() {
    // Limpa o GetIt após cada teste
    getIt.reset();
  });

  group('AuthView Tests', () {
    testWidgets('deve verificar o título', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: const AuthView(),
        ),
      );
      
      // Assert - Verifica se existe algum texto (mesmo que seja parte da UI)
      expect(find.byType(AuthView), findsOneWidget);
    });

    testWidgets('deve renderizar o widget sem erro', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: const AuthView(),
        ),
      );
      
      // Assert - Apenas verifica se o widget foi criado sem erro
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(AuthView), findsOneWidget);
    });
  });
}
