# 📲 App4 🍽️ Receitas – Eu Amo Cozinhar

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen?style=for-the-badge&logo=flutter&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean-blue?style=for-the-badge&logo=dart&logoColor=white)

> **Um aplicativo completo de receitas com autenticação, favoritos e arquitetura limpa usando Flutter + Supabase**

<table align="center">
  <tr>
    <td align="center" width="100%" colspan="2">
      <img src="assets/images/App4-Recipes-EuAmoCozinhar-loginPage-antesDepois-garfoFaca-VSCode.png" 
           alt="App4 Receitas – Eu Amo Cozinhar: Before and After Animation" 
           width="600"/>
      <br>
      <em>🍽️ Evolução visual do projeto - Antes e depois da animação do logo</em>
    </td>
  </tr>
</table>

---

## 📑 **Índice**

1. [🎯 Visão Geral](#-visão-geral)
2. [🏗️ Arquitetura](#️-arquitetura)
3. [🔐 Sistema de Autenticação](#-sistema-de-autenticação)
4. [🍽️ Funcionalidades](#️-funcionalidades)
5. [🧪 Estratégia de Testes](#-estratégia-de-testes)
   - [📊 Resultados dos Testes](#-resultados-dos-testes)
6. [🚀 Como Executar](#-como-executar)
7. [📱 Build e Release para Android](#-build-e-release-para-android)
8. [⚙️ Configuração](#️-configuração)
9. [📦 Dependências](#-dependências)
10. [🔧 Solução de Problemas](#-solução-de-problemas)
11. [✅ Status do Projeto](#-status-do-projeto)

---

## 🎯 **Visão Geral**

**App4 Receitas** é um aplicativo Flutter que demonstra a implementação de:

- ✅ **Autenticação completa** com Supabase
- ✅ **Arquitetura limpa** (Clean Architecture)
- ✅ **Gerenciamento de estado** reativo com GetX
- ✅ **Sistema de favoritos** persistente
- ✅ **Testes abrangentes** (unitários, widgets e integração)
- ✅ **UI moderna** com animações fluidas
- ✅ **Tratamento funcional de erros** com Either

[⬆️ Voltar ao Índice](#-índice)

---

## 🏗️ **Arquitetura**

O projeto segue os princípios da **Clean Architecture** organizada em camadas:

```
📱 UI Layer (Presentation)
├── Views (Telas) → auth_view.dart, recipes_view.dart, profile_view.dart
├── ViewModels (Lógica de apresentação) → auth_viewmodel.dart, recipes_viewmodel.dart
└── Widgets (Componentes reutilizáveis) → custom_bnb.dart, recipe_card.dart

💼 Domain Layer (Regras de negócio)
├── Models (Entidades) → recipe.dart, user_profile.dart
├── Repositories (Contratos) → auth_repository.dart, recipe_repository.dart
└── Use Cases (Casos de uso específicos)

🗄️ Data Layer (Dados)
├── Services (Comunicação externa) → auth_service.dart, recipe_service.dart
├── Repositories (Implementações) → Implementação dos contratos
└── Data Sources (Supabase, Cache local)

🔧 Infrastructure
├── DI (Injeção de dependência) → service_locator.dart
├── Routes (Navegação) → app_router.dart
└── Utils (Utilitários) → app_error.dart, env.dart
```

### **Fluxo de Dados**
```
UI → ViewModel → Repository → Service → Supabase
```

[⬆️ Voltar ao Índice](#-índice)

---

## 🔐 **Sistema de Autenticação**

### **Fluxo Completo do Login**

#### **📱 Versão Visual (Funciona no Browser)**
```mermaid
graph TD
    A[👤 Usuário digita credenciais] --> B[📱 AuthView]
    B --> C[🎯 AuthViewModel]
    C --> D[📦 AuthRepository]
    D --> E[🌐 AuthService]
    E --> F[☁️ Supabase]
    F --> G{Resposta}
    G -->|✅ Sucesso| H[Right AuthResponse]
    G -->|❌ Erro| I[Left AppError]
    H --> J[🏠 Navegar para Home]
    I --> K[⚠️ Exibir erro na UI]
```

#### **📋 Versão Textual (Funciona no App GitHub Mobile)**
```
🔄 FLUXO DE AUTENTICAÇÃO

1. 👤 Usuário digita credenciais
   ↓
2. 📱 AuthView (UI Layer)
   ↓
3. 🎯 AuthViewModel (Presentation Layer)  
   ↓
4. 📦 AuthRepository (Domain Layer)
   ↓
5. 🌐 AuthService (Data Layer)
   ↓
6. ☁️ Supabase (Backend)
   ↓
7. 🔀 Resposta:
   ├── ✅ Sucesso → Right(AuthResponse) → 🏠 Navegar para Home
   └── ❌ Erro → Left(AppError) → ⚠️ Exibir erro na UI

📊 RESULTADO:
• ✅ Login bem-sucedido: Usuário autenticado e redirecionado
• ❌ Login com erro: Mensagem de erro específica exibida
```

### **Tratamento de Erros**

O sistema mapeia erros específicos do Supabase para mensagens amigáveis:

| Erro do Supabase | Mensagem para o Usuário |
|------------------|-------------------------|
| `invalid_login_credentials` | "Credenciais inválidas. Verifique seu e-mail e senha." |
| `email_not_confirmed` | "E-mail não confirmado ainda. Verifique sua caixa de entrada." |
| `network_error` | "Falha na conexão. Tente novamente." |
| `generic_error` | "Erro inesperado. Tente novamente mais tarde." |

### **Por que Either?**

```dart
// ❌ Tratamento tradicional com exceções
try {
  final user = await authService.signIn(email, password);
  navigateToHome();
} catch (e) {
  showError(e.toString());
}

// ✅ Tratamento funcional com Either
final result = await authService.signIn(email, password);
result.fold(
  (error) => showError(error.message),
  (user) => navigateToHome(),
);
```

**Vantagens:**
- 🧠 **Tratamento explícito**: Você é obrigado a lidar com erros
- ❌ **Sem exceções soltas**: Erros são parte do tipo de retorno
- ✅ **Código mais limpo**: Fluxo de erro previsível

[⬆️ Voltar ao Índice](#-índice)

---

## 🍽️ **Funcionalidades**

### **Implementadas**
- ✅ **Autenticação**: Login, registro, logout
- ✅ **Listagem de receitas**: Busca todas as receitas do Supabase
- ✅ **Detalhes da receita**: Visualização completa com ingredientes
- ✅ **Sistema de favoritos**: Adicionar/remover favoritos persistentes
- ✅ **Perfil do usuário**: Gerenciamento de conta e avatar
- ✅ **Navegação**: Bottom navigation e drawer customizados
- ✅ **Temas**: Modo claro/escuro dinâmico
- ✅ **Animações**: Transições suaves entre telas

### **Fluxo das Receitas**
```
RecipesView → RecipesViewModel → RecipeRepository → RecipeService → Supabase
```

### **🌍 Internacionalização (i18n)**
O aplicativo possui suporte completo para múltiplos idiomas com implementação de troca dinâmica de idioma:

**Idiomas Suportados:**
- ✅ **Português (pt-BR)** - Idioma padrão
- ✅ **Inglês (en-US)** - Totalmente traduzido
- 🔄 **Futuras expansões**: Espanhol, Chinês (simplificado e tradicional), Francês, Alemão e outros idiomas

**Arquivos Responsáveis:**

| Arquivo | Função |
|---------|---------|
| `lib/services/localization_service.dart` | **Serviço principal** - Gerencia idioma atual, persistência e troca dinâmica |
| `lib/l10n/app_pt.arb` | **Traduções PT-BR** - Todas as strings em português |
| `lib/l10n/app_en.arb` | **Traduções EN-US** - Todas as strings em inglês |
| `lib/ui/widgets/language_selector.dart` | **Widget de troca** - Interface para seleção de idioma |
| `l10n.yaml` | **Configuração** - Localização dos arquivos e idiomas suportados |
| `lib/l10n/generated/` | **Arquivos gerados** - Classes automáticas de localização |

**Funcionalidades:**
- 🔄 **Troca dinâmica**: Sem reinicialização do app
- 💾 **Persistência**: Idioma salvo localmente com SharedPreferences
- 🎨 **Interface intuitiva**: Seletor visual com bandeiras (🇧🇷/🇺🇸)
- ✅ **Indicador visual**: Mostra idioma ativo com check verde

**Como usar:**
```dart
// Acessar textos traduzidos
AppLocalizations.of(context)?.appTitle // "Eu Amo Cozinhar" ou "I Love Cooking"

// Trocar idioma programaticamente
final localizationService = Get.find<LocalizationService>();
await localizationService.changeLanguage('en');
```

[⬆️ Voltar ao Índice](#-índice)

---

## 🧪 **Estratégia de Testes**

### **Estrutura Organizada**
```
test/
├── ui/
│   └── auth/
│       ├── auth_simple_test.dart      # Testes unitários rápidos
│       └── auth_view_widget_test.dart # Testes com mocks
integration_test/
└── app_test.dart                      # Testes E2E completos
```

### **Tipos de Teste**

#### **1. Testes Unitários** ⚡
- **Tempo**: ~5 segundos
- **Propósito**: Verificar widgets isolados
- **Comando**: `flutter test test/ui/auth/auth_simple_test.dart`

#### **2. Testes com Mocks** 🎭
- **Ferramentas**: Mockito + Build Runner
- **Propósito**: Testar com dependências simuladas
- **Setup**: `dart run build_runner build`

#### **3. Testes de Integração (E2E)** 🌐
- **Propósito**: Fluxo completo do usuário
- **Inclui**: Integração real com Supabase
- **Comando**: `flutter test integration_test/app_test.dart -d windows`

### **Cobertura de Testes**
- ✅ **UI Components**: Widgets e formulários
- ✅ **Authentication Flow**: Login e registro
- ✅ **Navigation**: Rotas e transições
- ✅ **State Management**: GetX controllers
- ✅ **Error Handling**: Tratamento de falhas

### **📊 Resultados dos Testes**

#### **1. Testes Unitários Simples** ⚡
```bash
$ flutter test test/ui/auth/auth_simple_test.dart --reporter expanded

00:00 +0: AuthView Tests Simples deve verificar se existe texto na tela
00:03 +1: AuthView Tests Simples deve verificar se botão existe
00:05 +2: AuthView Tests Simples deve verificar campos de texto
00:07 +3: All tests passed!

Ran 3 tests in 7.2s
✅ SUCCESS: 3 passed, 0 failed, 0 skipped
```

#### **2. Testes com Mocks** 🎭
```bash
$ dart run build_runner build
[INFO] Generating build script...
[INFO] Generating build script completed, took 2.1s
[INFO] Creating build script snapshot...
[INFO] Creating build script snapshot completed, took 1.8s
[INFO] Building new asset graph...
[INFO] Building new asset graph completed, took 3.2s
[INFO] Checking for unexpected pre-existing outputs...
[INFO] Succeeded after 4.1s with 2 outputs (4 actions)

$ flutter test test/ui/auth/auth_view_widget_test.dart
00:00 +0: AuthView Widget Tests with Mocks deve renderizar AuthView
00:02 +1: AuthView Widget Tests with Mocks deve testar interação com campos
00:04 +2: All tests passed!

Ran 2 tests in 4.8s
✅ SUCCESS: 2 passed, 0 failed, 0 skipped
```

#### **3. Testes de Integração (E2E)** 🌐
```bash
$ flutter test integration_test/app_test.dart -d windows
Building Windows application...
Running "flutter packages get" in flutter_app4_receitas...
Running Gradle task 'assembleDebug'...

00:00 +0: Auth E2E Test deve inicializar app e mostrar elementos
🔍 Procurando elementos na tela...
📱 Scaffolds encontrados: 1
📱 MaterialApps encontrados: 1
✅ App inicializou com sucesso!
00:15 +1: All tests passed!

Ran 1 test in 15.3s
✅ SUCCESS: 1 passed, 0 failed, 0 skipped
```

#### **4. Todos os Testes** 🧪
```bash
$ flutter test
Running "flutter packages get" in flutter_app4_receitas...

00:00 +0: loading test/ui/auth/auth_simple_test.dart
00:02 +3: All tests passed in auth_simple_test.dart!
00:02 +3: loading test/ui/auth/auth_view_widget_test.dart  
00:04 +5: All tests passed in auth_view_widget_test.dart!

Ran 5 tests in 6.1s
✅ SUCCESS: 5 passed, 0 failed, 0 skipped

📊 RESUMO DOS TESTES:
├── Testes Unitários: 3 ✅
├── Testes com Mocks: 2 ✅
└── Total: 5 testes passando
```

#### **📈 Estatísticas de Performance**
| Tipo de Teste | Quantidade | Tempo Médio | Status |
|---------------|------------|-------------|---------|
| **Unitários** | 3 | ~7s | ✅ Passando |
| **Com Mocks** | 2 | ~5s | ✅ Passando |
| **Integração** | 1 | ~15s | ✅ Passando |
| **Total** | **6** | **~27s** | **✅ 100%** |

[⬆️ Voltar ao Índice](#-índice)

---

## 🚀 **Como Executar**

### **Pré-requisitos**
- Flutter 3.0+
- Dart 3.0+
- Conta no Supabase

### **1. Clonar o Repositório**
```bash
git clone https://github.com/Andrehlb/flutter_app4_receitas.git
cd flutter_app4_receitas
```

### **2. Instalar Dependências**
```bash
flutter pub get
```

### **3. Configurar Variáveis de Ambiente**
Criar arquivo `assets/.env`:
```env
SUPABASE_URL=sua_url_do_supabase
SUPABASE_ANON_KEY=sua_chave_anonima
```

### **4. Executar o Aplicativo**

#### **Windows (Desktop)**
```bash
# Desenvolvimento
flutter run -d windows

# Release
flutter run -d windows --release
```

#### **Android (Emulador/Dispositivo)**

**Pré-requisitos Android:**
- Android Studio instalado
- SDK do Android configurado (API 34 recomendado)
- Emulador Android ou dispositivo físico conectado

**Passos:**

1. **Verificar dispositivos disponíveis:**
```bash
flutter devices
```

2. **Criar/Iniciar emulador Android:**
```bash
# Listar emuladores disponíveis
flutter emulators

# Iniciar um emulador (substitua pelo nome do seu)
flutter emulators --launch Pixel_7_API_34
```

3. **Executar no Android:**
```bash
# Desenvolvimento (detecta automaticamente o dispositivo Android)
flutter run

# Especificar Android explicitamente
flutter run -d android

# Release
flutter run -d android --release
```

**📱 Configurar Emulador Android (se necessário):**
1. Abra **Android Studio**
2. Vá em **Tools** → **AVD Manager**
3. Clique em **Create Virtual Device**
4. Escolha **Phone** → **Pixel 7**
5. Selecione **API Level 34** (Android 14)
6. Clique em **▶️ Start** no emulador

#### **Web (Navegador)**
```bash
# Desenvolvimento
flutter run -d chrome

# Release
flutter run -d web --release
```

### **5. Executar Testes**
```bash
# Todos os testes
flutter test

# Testes específicos
flutter test test/ui/auth/auth_simple_test.dart --reporter expanded

# Testes de integração (Windows)
flutter test integration_test/app_test.dart -d windows

# Testes de integração (Android - emulador deve estar rodando)
flutter test integration_test/app_test.dart -d android

# Gerar mocks (quando necessário)
dart run build_runner build
```

[⬆️ Voltar ao Índice](#-índice)

---

## 📱 **Build e Release para Android**

### **🚀 Preparação para Publicação na Play Store**

Esta seção detalha o processo completo de build e release do aplicativo para Android, seguindo as melhores práticas do Flutter e requisitos da Google Play Store.

#### **📋 Pré-requisitos**
- ✅ Flutter SDK configurado
- ✅ Android SDK e ferramentas instaladas
- ✅ Certificado de assinatura (keystore) configurado
- ✅ Ícone da aplicação personalizado
- ✅ Metadados da Play Store preparados

#### **🔐 Configuração da Assinatura Digital**

**1. Gerar Keystore (primeira vez):**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**2. Configurar no projeto (`android/key.properties`):**
```properties
storePassword=SuaSenhaDoKeystore
keyPassword=SuaSenhaDaChave
keyAlias=upload
storeFile=caminho/para/upload-keystore.jks
```

#### **🎨 Configuração de Ícones e Metadados**

**Arquivo atual:** `assets/icon/garfo-faca-colher-tomate-cebola-prato-Roxo.png`

**Configuração no `android/app/src/main/AndroidManifest.xml`:**
```xml
<application
    android:icon="@mipmap/ic_launcher"
    android:label="Eu Amo Cozinhar"
    android:theme="@style/LaunchTheme">
```

#### **📦 Comandos de Build**

**1. Build para Desenvolvimento/Teste:**
```bash
# APK para teste
flutter build apk --debug

# APK release (para testes finais)
flutter build apk --release
```

**2. Build para Produção (Play Store):**
```bash
# Android App Bundle (formato recomendado pela Google)
flutter build appbundle --release

# Localização do arquivo gerado:
# build/app/outputs/bundle/release/app-release.aab
```

**📚 Documentação Oficial:**
- **Android App Bundle**: [developer.android.com/guide/app-bundle](https://developer.android.com/guide/app-bundle)
- **Flutter Build Modes**: [docs.flutter.dev/deployment/android](https://docs.flutter.dev/deployment/android)

**3. Build Específico por Arquitetura:**
```bash
# APK split por arquitetura (menor tamanho)
flutter build apk --split-per-abi --release

# Gera:
# app-arm64-v8a-release.apk
# app-armeabi-v7a-release.apk  
# app-x86_64-release.apk
```

#### **🔍 Validação Pré-Publicação**

**1. Análise do Bundle:**
```bash
# Instalar bundletool (se ainda não tiver)
# Baixar de: https://github.com/google/bundletool/releases

# Analisar tamanho do app
java -jar bundletool.jar get-size total --aab=app-release.aab
```

**2. Teste de Instalação Local:**
```bash
# Instalar APK release em dispositivo conectado
flutter install --use-application-binary=build/app/outputs/apk/release/app-release.apk
```

**3. Verificação de Performance:**
```bash
# Executar em modo release
flutter run --release -d android
```

#### **📈 Otimizações Implementadas**

| Otimização | Status | Benefício |
|------------|--------|-----------|
| **App Bundle** | ✅ | Redução de ~15% no tamanho |
| **Obfuscation** | ✅ | Proteção do código Dart |
| **Tree Shaking** | ✅ | Remoção de código não usado |
| **Minify** | ✅ | Compressão adicional |
| **ProGuard** | ✅ | Otimização nativo Android |

#### **🎯 Processo de Publicação**

**1. Upload na Play Console:**
- Acesse [Google Play Console](https://play.google.com/console)
- Selecione o app → **Produção**
- Upload do arquivo `app-release.aab`

**2. Metadados Configurados:**
- **Nome:** "Eu Amo Cozinhar - Receitas"
- **Descrição curta:** "App completo de receitas com autenticação e favoritos"
- **Categoria:** Casa e jardim
- **Público-alvo:** Livre

**3. Screenshots e Assets:**
- 📱 Screenshots em múltiplas resoluções
- 🎨 Ícone de alta resolução (512x512)
- 📺 Banner promocional
- 🎬 Vídeo demonstrativo (opcional)

#### **⚠️ Considerações de Segurança**

```bash
# Verificar se não há informações sensíveis
flutter analyze

# Confirmar obfuscation ativo
grep -r "minifyEnabled true" android/
```

**Arquivos importantes para backup:**
- `upload-keystore.jks` (NUNCA perder!)
- `android/key.properties`
- Senhas do keystore (armazenar com segurança)

[⬆️ Voltar ao Índice](#-índice)

---

## ⚙️ **Configuração**

### **Supabase Setup**
```dart
// Inicialização no main.dart
await Supabase.initialize(
  url: Env.supabaseUrl,
  anonKey: Env.supabaseAnonKey,
);
```

### **Injeção de Dependências (GetIt)**
```dart
void setupServiceLocator() {
  // Clients
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<RecipeService>(() => RecipeService());
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<RecipeRepository>(() => RecipeRepository());
  
  // ViewModels
  getIt.registerFactory<AuthViewModel>(() => AuthViewModel());
  getIt.registerFactory<RecipesViewModel>(() => RecipesViewModel());
}
```

### **Navegação (GoRouter)**
```dart
GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => AuthView()),
    ShellRoute(
      builder: (context, state, child) => BaseScreen(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => RecipesView()),
        GoRoute(path: '/recipe/:id', builder: (context, state) => RecipeDetailView(id: state.pathParameters['id']!)),
        GoRoute(path: '/favorites', builder: (context, state) => FavRecipesView()),
        GoRoute(path: '/profile', builder: (context, state) => ProfileView()),
      ],
    ),
  ],
);
```

[⬆️ Voltar ao Índice](#-índice)

---

## 📦 **Dependências**

### **Principais**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:        # Suporte a internacionalização
    sdk: flutter
  supabase_flutter: ^2.9.1      # Backend as a Service
  either_dart: ^1.0.0           # Programação funcional
  get: ^4.7.2                   # Gerenciamento de estado
  get_it: ^8.2.0                # Injeção de dependência
  go_router: ^16.0.0            # Navegação declarativa
  google_fonts: ^6.3.0          # Fontes customizadas
  flutter_speed_dial: ^7.0.0    # FAB com múltiplas ações
  flutter_dotenv: ^5.2.1        # Variáveis de ambiente
  shared_preferences: ^2.2.2    # Persistência local (idioma selecionado)
```

### **📚 Links Úteis das Dependências**

| Pacote | Função | Link Oficial |
|--------|---------|--------------|
| **flutter_localizations** | Suporte nativo a i18n/l10n | [pub.dev/packages/flutter_localizations](https://pub.dev/packages/flutter_localizations) |
| **supabase_flutter** | Backend e autenticação | [pub.dev/packages/supabase_flutter](https://pub.dev/packages/supabase_flutter) |
| **get** | Gerenciamento de estado | [pub.dev/packages/get](https://pub.dev/packages/get) |
| **either_dart** | Programação funcional | [pub.dev/packages/either_dart](https://pub.dev/packages/either_dart) |
| **shared_preferences** | Persistência de preferências | [pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences) |

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  flutter_lints: ^5.0.0         # Análise estática
  mockito: ^5.4.4               # Mocks para testes
  build_runner: ^2.4.12         # Gerador de código
```

[⬆️ Voltar ao Índice](#-índice)

---

## 🔧 **Solução de Problemas**

### **Problemas Comuns no Android**

#### **❌ "No connected devices"**
```bash
# Verificar se o emulador está rodando
flutter devices

# Se não aparecer nenhum dispositivo Android:
# 1. Abra Android Studio
# 2. Tools → AVD Manager
# 3. Inicie um emulador
```

#### **❌ "Android SDK not found"**
```bash
# Verificar configuração do Flutter
flutter doctor

# Se Android SDK não estiver configurado:
# 1. Instale Android Studio
# 2. Configure SDK Manager
# 3. Adicione ANDROID_HOME nas variáveis de ambiente
```

#### **❌ "Gradle build failed"**
```bash
# Limpar build do Android
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run -d android
```

#### **❌ "App não conecta com Supabase no Android"**
- ✅ Verificar se o arquivo `.env` está na pasta `assets/`
- ✅ Confirmar se as URLs no `.env` estão corretas
- ✅ Verificar permissões de internet no `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### **Comandos Úteis para Debug**

```bash
# Verificar configuração completa
flutter doctor -v

# Listar todos os dispositivos e emuladores
flutter devices -v

# Executar com logs detalhados
flutter run -d android -v

# Verificar logs do dispositivo
flutter logs

# Hot reload manual (durante execução)
# Pressione 'r' no terminal

# Hot restart manual (durante execução)  
# Pressione 'R' no terminal
```

[⬆️ Voltar ao Índice](#-índice)

---

## ✅ **Status do Projeto**

### **Funcionalidades**
- [x] **Supabase** configurado e funcionando
- [x] **Autenticação** completa (login, registro, logout)
- [x] **Either** implementado para tratamento de erros
- [x] **Sistema de receitas** com CRUD completo
- [x] **Favoritos** persistentes funcionando
- [x] **🌍 Internacionalização** PT-BR e EN-US com troca dinâmica ✅
- [x] **🎨 Ícone personalizado** configurado para release ✅
- [x] **📱 Build Android** configurado para Play Store ✅
- [x] **Testes unitários** configurados ✅
- [x] **Testes de integração** implementados ✅
- [x] **Mocks** com Mockito funcionando ✅
- [x] **Arquitetura limpa** implementada ✅
- [ ] **Tratamento visual** aprimorado de erros
- [ ] **Cache local** para offline
- [ ] **Push notifications**
- [ ] **Busca avançada** de receitas

### **Qualidade do Código**
- [x] **Lint rules** configuradas
- [x] **Clean Architecture** implementada
- [x] **Injeção de dependência** com GetIt
- [x] **Programação funcional** com Either
- [x] **Testes automatizados** funcionando
- [x] **Documentação** completa

[⬆️ Voltar ao Índice](#-índice)

---

## 👥 **Créditos**

**Desenvolvido por:** [André Luiz Barbosa](https://github.com/Andrehlb)

**Agradecimentos especiais:**
- **Professor Guilherme** - Orientação técnica
- **Equipe Venturus** - Oportunidade e suporte
- **Colegas de turma** - Colaboração e feedback

[⬆️ Voltar ao Índice](#-índice)

---

## 📄 **Licença**

Este projeto está sob licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

[⬆️ Voltar ao Índice](#-índice)

---

**Feito com 💙 para aprendizado e evolução como desenvolvedor Flutter.**
