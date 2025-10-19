import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.mapOrNull(
          error: (state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: state.maybeWhen(
                loading: () => null,
                orElse:
                    () => () {
                      context.read<AuthBloc>().add(
                        const AuthEvent.signInWithGoogle(),
                      );
                    },
              ),
              icon: state.maybeWhen(
                loading:
                    () => const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                orElse: () => const Icon(Icons.g_mobiledata, size: 24),
              ),
              label: state.maybeWhen(
                loading: () => const Text('Iniciando sesión...'),
                orElse: () => const Text('Continuar con Google'),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
