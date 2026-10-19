import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/core/widgets/app_version_label.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:reading_app/features/auth/presentation/widgets/google_sign_in_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (user) {
            // Usuario registrado exitosamente, navegar a home y limpiar stack
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Registro'), centerTitle: true),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '¡Únete a Reading App!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Crea tu cuenta para empezar',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const AuthForm(isRegister: true),
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
                    const Text('¿Ya tienes cuenta? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Inicia sesión'),
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
    );
  }
}
