import 'package:app4_receitas/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Column(
      children: [
        _animatedLogo(controller: _animationController),
        const SizedBox(height: 16),
        Text(
          'Eu Amo Cozinhar',
          style: GoogleFonts.dancingScript(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          viewModel.isLoginMode ? 'Entre na sua conta' : 'Crie uma nova conta',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
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
    return TextFormField(
      controller: viewModel.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'E-mail',
        hintText: 'Digite seu e-mail',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: viewModel.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        controller: viewModel.passwordController,
        obscureText: viewModel.obscurePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'Senha',
          hintText: 'Digite sua senha',
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
        visible: viewModel.errorMessage.isNotEmpty,
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

Widget _buildSubmitButton() {