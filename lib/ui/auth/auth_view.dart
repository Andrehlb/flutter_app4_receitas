import 'package:app4_receitas/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app4_receitas/ui/widgets/language_selector.dart';
import 'package:app4_receitas/l10n/generated/app_localizations.dart';
import 'auth_viewmodel.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

  class _AuthViewState extends State<AuthView> // Estado da View
    with SingleTickerProviderStateMixin { // Para animações
   final viewModel = getIt<AuthViewModel>(); // Instância do ViewModel

     late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1000),
        )..addStatusListener((listener) {
          if (listener == AnimationStatus.completed) {
            _animationController.reverse();
          } else if (listener == AnimationStatus.dismissed) {
            _animationController.forward();
          }
        });

    _animation = Tween(begin: 50.0, end: 200.0).animate(_animationController);
    _animation.addListener(() => setState(() {}));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Form(
            key: viewModel.formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    if (!viewModel.isLoginMode) ...[
                      _buildConfirmPasswordField(),
                      const SizedBox(height: 16),
                      _buildUsernameField(),
                      const SizedBox(height: 16),
                      _buildAvatarUrlField(),
                    ],
                    const SizedBox(height: 32),
                    _buildErrorMessage(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                    const SizedBox(height: 32),
                    _buildToggleModeButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      children: [
        _animatedLogo(controller: _animationController),
        const SizedBox(height: 16),
        Text(
          l10n?.appTitle ?? 'Eu Amo Cozinhar',
          style: GoogleFonts.dancingScript(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          viewModel.isLoginMode 
            ? (l10n?.signInSubtitle ?? 'Entre na sua conta')
            : (l10n?.signUpSubtitle ?? 'Crie uma nova conta'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
        ),
      ],
    );
  }
  Widget _animatedLogo({required AnimationController controller}) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final sizeTween = Tween(
          begin: 50.0,
          end: 200.0,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

        final colorTween = ColorTween(
          begin: Theme.of(context).colorScheme.onError,
          end: Theme.of(context).colorScheme.primary,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.bounceInOut));

        final angleTween = Tween(
          begin: 0.0,
          end: 2 * 3.14,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

        return Transform.rotate(
          angle: angleTween.value,
          child: SizedBox(
            height: 200,
            child: Icon(
              Icons.restaurant_menu,
              size: sizeTween.value,
              color: colorTween.value,
            ),
          ),
        );
      },
    );
  }


  Widget _buildEmailField() {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      key: const ValueKey('emailField'),
      controller: viewModel.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: l10n?.emailLabel ?? 'E-mail',
        hintText: l10n?.emailHint ?? 'Digite seu e-mail',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: viewModel.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    final l10n = AppLocalizations.of(context);
    return Obx(
      () => TextFormField(
        key: const ValueKey('passwordField'),
        controller: viewModel.passwordController,
        obscureText: viewModel.obscurePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: l10n?.passwordLabel ?? 'Senha',
          hintText: l10n?.passwordHint ?? 'Digite sua senha',
          prefixIcon: const Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              viewModel.obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: viewModel.toggleObscurePassword,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: viewModel.validatePassword,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      key: const ValueKey('confirmPasswordField'),
      controller: viewModel.confirmPasswordController,
      obscureText: viewModel.obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Confirmar senha',
        hintText: 'Digite novamente sua senha',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            viewModel.obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: viewModel.toggleObscurePassword,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: viewModel.validateConfirmPassword,
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      key: const ValueKey('usernameField'),
      controller: viewModel.usernameController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Usuário',
        hintText: 'Digite seu nome de usuário',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: viewModel.validateUsername,
    );
  }

  Widget _buildAvatarUrlField() {
    return TextFormField(
      controller: viewModel.avatarUrlController,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'URL do Avatar',
        hintText: 'Digite a URL do seu avatar',
        prefixIcon: const Icon(Icons.image_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: viewModel.validateAvatarUrl,
    );
  }

  Widget _buildErrorMessage() {
    return Obx(
      () => Visibility(
        visible: viewModel.errorMessage.isNotEmpty, // visible + valor booleano
        child: Text(
          viewModel.errorMessage,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  } // _buildErrorMessage

  Widget _buildSubmitButton() { // botão de envio
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        key: const ValueKey('submitButton'),
        onPressed: viewModel.submit,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ), // shape
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ), // ElevatedButton.styleFrom
        child: viewModel.isSubmitting
            ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ), // CircularProgressIndicator
              )
            : Text(
                viewModel.isLoginMode 
                  ? (AppLocalizations.of(context)?.signInButton ?? 'ENTRAR')
                  : (AppLocalizations.of(context)?.signUpButton ?? 'CADASTRAR'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  } // _buildSubmitButton

  Widget _buildToggleModeButton() {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        // Botão principal de alternância (mais visível)
        if (viewModel.isLoginMode)
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: viewModel.isSubmitting ? null : viewModel.toggleMode,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              child: Text(
                l10n?.signUpButton ?? 'CRIAR CONTA',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        
        SizedBox(height: 16),
        
        // Link secundário (para voltar ao login)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewModel.isLoginMode 
                ? (l10n?.noAccountQuestion ?? 'Não tem uma conta? ')
                : (l10n?.hasAccountQuestion ?? 'Já tem uma conta? '),
            ),
            TextButton(
              onPressed: viewModel.isSubmitting ? null : viewModel.toggleMode,
              child: Text(
                viewModel.isLoginMode 
                  ? (l10n?.signUpLink ?? 'Cadastre-se')
                  : (l10n?.signInLink ?? 'Entre aqui'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ], // children
        ),
      ],
    );
  } // _buildToggleModeButton
} // AuthView