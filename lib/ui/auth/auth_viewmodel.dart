import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app4_receitas/data/repositories/auth_repository.dart';
import 'package:app4_receitas/di/service_locator.dart';

class AuthViewModel extends GetxController {
  final _repository = getIt<AuthRepository>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final avatarUrlController = TextEditingController();

  // Estados
  final _obscurePassword = true.obs;
  final _isSubmitting = false.obs;
  final _isLoginMode = true.obs;
  final _errorMessage = ''.obs;

  // Getters
  bool get obscurePassword => _obscurePassword.value;
  bool get isSubmitting => _isSubmitting.value;
  bool get isLoginMode => _isLoginMode.value;
  String get errorMessage => _errorMessage.value;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe o e-mail';
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    ).hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Precisa de letra minúscula';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Precisa de letra maiúscula';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Precisa de número';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\/;]').hasMatch(value)) {
      return 'Precisa de caractere especial';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirme a senha';
    if (value != passwordController.text) return 'As senhas não coincidem';
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Informe o nome de usuário';
    if (value.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  String? validateAvatarUrl(String? value) {
    if (value == null || value.isEmpty) return 'Informe a URL do avatar';
    if (!RegExp(
      r'^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w- ./?%&=]*)?$',
    ).hasMatch(value)) {
      return 'URL inválida';
    }
    return null;
  }

  void toggleObscurePassword() =>
      _obscurePassword.value = !_obscurePassword.value;

  Future<void> submit() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;
    _isSubmitting.value = true;
    if (isLoginMode) {
      await login();
    } else {
      await register();
    }
    _isSubmitting.value = false; // para habilitar o botão de submit
  }

  Future<void> login() async {
    final response = await _repository.signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    response.fold(
      (left) {
        _errorMessage.value = left.message;
        print('❌ Erro no login: ${left.message}');
      },
      (right) {
        print('✅ Login bem-sucedido: $right');
        _errorMessage.value = ''; // Limpa mensagem de erro
        _clearFields();
        
        // 🎯 NAVEGAÇÃO PÓS-LOGIN: Forçar navegação para home
        // O AppRouter deveria redirecionar automaticamente, mas como fallback:
        Get.offAllNamed('/');
      },
    );
  }

  Future<void> register() async {
    // Done: lógica para registro
    final response = await _repository.signUp(
      email: emailController.text,
      password: passwordController.text,
      username: usernameController.text,
      avatarUrl: avatarUrlController.text,
    );

    response.fold(
      (left) {
        _errorMessage.value = left.message;
        print(errorMessage);
      },
      (right) {
        _errorMessage.value =
            'O e-amil de confirmaçõ já foi enviado para tua caixa de entrada. Verifica por favor.';
        _isLoginMode.value = true; // Muda para modo de login após registro
        print(right);
        _clearFields();
      },
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    avatarUrlController.dispose();
    super.onClose();
  }

  void toggleMode() {
    _isLoginMode.value = !_isLoginMode.value;
    _isSubmitting.value = false;
    _clearFields();
    _obscurePassword.value = true;

    // * update
    // Necessário para atualizar a UI
    update();
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    usernameController.clear();
    avatarUrlController.clear();
  }
}