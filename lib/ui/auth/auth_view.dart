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