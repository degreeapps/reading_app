import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/core/widgets/app_version_label.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:reading_app/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (user) {
            // Usuario autenticado exitosamente, navegar a home y limpiar stack
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Iniciar Sesión'), centerTitle: true),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '¡Bienvenido a Reading App!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const AuthForm(),
                  const SizedBox(height: 16),
                  const Text(
                    'O',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const GoogleSignInButton(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes cuenta? '),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Regístrate'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const AppVersionLabel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
