# 📲 App4 🍽️ Receitas – Autenticação com Supabase

* ✅ Onde tudo começa e termina
* ✅ Fluxo completo da autenticação
* ✅ Diferença entre front-end e back-end
* ✅ Scripts envolvidos
* ✅ Resumo visual e técnico

```md

Este é um projeto de criação de um aplicativo de receitas e sistemas de favoritos, usando Dart-Flutter e com
uma arquitetura limpa, com Supabase.
Este projeto em camadas com foco em boas práticas e uso de Vários pacotes, como o `either_dart` para tratamento funcional de sucesso/erro.


Aqui é possível observar e aprender como organizar a lógica de autenticação com boas práticas e um fluxo robusto de login.

```

---

## ✅ Onde tudo começa e termina?

- 👤 O **usuário digita** e-mail e senha na tela de login (`auth_view.dart`)
- 📤 O **ViewModel envia** os dados para o `AuthRepository`
- 🔁 O **AuthRepository repassa** para o `AuthService`
- 🌐 O **AuthService envia** ao Supabase (Back-end) usando `signInWithPassword`
- 📥 A resposta pode ser:
  - ✅ Sucesso → retorna `Right(AuthResponse)`
  - ❌ Erro → retorna `Left(AppError)`

O fluxo termina com o **ViewModel tratando o resultado** com `fold`, exibindo mensagens para o usuário conforme o erro retornado.

---

## ✅ FRONTEND vs BACKEND

| Papel         | Descrição                                                                 |
|---------------|---------------------------------------------------------------------------|
| **Frontend**  | Código que o usuário interage. Contém UI e lógica de interação com o app. |
| **Backend**   | Serviços externos como Supabase. Realizam a autenticação real de dados.   |

---

## 🔁 FLUXO COMPLETO DA AUTENTICAÇÃO

```

\[Usuário Digita] → auth\_view\.dart
↓
\[Envia ao ViewModel] → auth\_viewmodel.dart
↓
\[Chama AuthRepository] → auth\_repository.dart
↓
\[Chama AuthService] → auth\_service.dart
↓
\[Supabase (Back-end)] → valida email/senha
↓
\[Retorna Sucesso ou Erro] com Either
↓
\[ViewModel trata com fold] → isLeft/isRight
↓
\[Exibe feedback na UI]

````

---

## 🧠 Resumo visual da função `signInWithPassword`

```dart
Future<Either<AppError, AuthResponse>> signInWithPassword(...) async {
  try {
    final res = await _supabaseClient.auth.signInWithPassword(...);
    return Right(res); // ✅ Sucesso
  } on AuthException catch (e) {
    return Left(AppError(_mapAuthError(e), e)); // ❌ Erro de login
  } catch (e) {
    return Left(AppError('Autenticação falhou. Tente novamente.', e)); // ⚠️ Erro genérico
  }
}
````

| Resultado | Significado | Tipo de dado |
| --------- | ----------- | ------------ |
| ✅ Right   | Sucesso     | AuthResponse |
| ❌ Left    | Falha       | AppError     |

---

## ✅ Quais scripts fazem parte do fluxo?

| Script                          | Local                    | Papel                                          |
| ------------------------------- | ------------------------ | ---------------------------------------------- |
| `auth_view.dart`                | `lib/ui/auth/`           | Tela de login com campos de e-mail e senha     |
| `auth_viewmodel.dart`           | `lib/ui/auth/`           | Recebe dados do front e chama o repositório    |
| `auth_repository.dart`          | `lib/data/repositories/` | Orquestra o acesso ao serviço de autenticação  |
| `auth_service.dart`             | `lib/data/services/`     | Chama o Supabase com os dados recebidos        |
| `app_error.dart`                | `lib/utils/`             | Modela e encapsula os erros de forma funcional |
| `main.dart` + `app_router.dart` | `lib/`                   | Inicia o app, define rotas e navegação         |

---

## 🧩 Por que usar `Either`?

| Vantagem                   | Explicação                                                                   |
| -------------------------- | ---------------------------------------------------------------------------- |
| 🧠 Tratamento funcional    | Você recebe Left (erro) ou Right (sucesso) e decide o que fazer com `fold()` |
| ❌ Evita exceções soltas    | O consumidor não precisa usar `try/catch`, pois o erro já vem encapsulado    |
| ✅ Melhor controle de fluxo | Você sabe sempre quando houve erro ou sucesso, sem depender de throw         |

---

## ✨ Exemplo de uso do resultado no ViewModel

```dart
final result = await authService.signInWithPassword(email, password);

result.fold(
  (error) => print('Erro: ${error.message}'), // Left
  (success) => print('Sucesso: ${success.user.email}'), // Right
);
```

---

## 📦 Dependências principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^x.x.x
  either_dart: ^1.0.0
```

---

## 🚀 Como rodar o projeto

```bash
flutter pub get
flutter run
```

---

## ✅ Status

* [x] Supabase configurado
* [x] Autenticação com email/senha funcionando
* [x] Either implementado
* [x] ViewModel consome resultado corretamente
* [ ] Próximos passos: tratamento visual de erro e sucesso na interface

---

Feito com 💙 para estudos e evolução como desenvolvedor Flutter.

```

Agradecimentos:

- Professor Guilherme
- Raissa e demais meninas que vou pegar os nomes hahahaha para add aqui.
- Monitores, idem vou pergar os nomes para add aqui..
- Venturus, por me aceitarem, disponibilizarem esta oportunidade, pois sem o suporte de vocês, isto não seria possível.
```
