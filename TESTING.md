# Scripts de Teste - App4 Receitas

## 🚀 Comandos Rápidos

### Testes Unitários (Rápidos)
```bash
# Todos os testes unitários
flutter test

# Teste específico com output detalhado
flutter test test/ui/auth/auth_simple_test.dart --reporter expanded

# Apenas o teste simples
flutter test test/ui/auth/auth_simple_test.dart
```

### Testes com Mocks
```bash
# Gerar mocks automaticamente
dart run build_runner build

# Gerar mocks forçando regeneração
dart run build_runner build --delete-conflicting-outputs

# Executar testes com mocks
flutter test test/ui/auth/auth_view_widget_test.dart
```

### Testes de Integração
```bash
# Windows Desktop
flutter test integration_test/app_test.dart -d windows

# Android (se disponível)
flutter test integration_test/app_test.dart -d android

# iOS (se disponível) 
flutter test integration_test/app_test.dart -d ios
```

### Comandos de Debug
```bash
# Testes com output verboso
flutter test --reporter expanded

# Testes com coverage
flutter test --coverage

# Limpar cache antes dos testes
flutter clean && flutter pub get && flutter test
```

## 📊 Resultados Esperados

### ✅ Sucesso dos Testes Unitários:
```
00:05 +3: All tests passed!
```

### ✅ Sucesso dos Mocks:
```
Built with build_runner in 95s; wrote 1 output.
```

### ✅ Sucesso da Integração:
```
00:15 +2: All tests passed!
```

## 🛠️ Solução de Problemas

### Problema: "GetIt not registered"
```bash
# Solução: Verificar se o mock foi registrado no setUp()
getIt.registerLazySingleton<AuthViewModel>(() => mockAuthViewModel);
```

### Problema: "Build runner não gera mocks"
```bash
# Solução: Usar flag de delete
dart run build_runner build --delete-conflicting-outputs
```

### Problema: "Integration test não inicia"
```bash
# Solução: Verificar arquivo .env
# Deve estar em assets/.env com:
SUPABASE_URL=sua_url
SUPABASE_ANON_KEY=sua_chave
```
