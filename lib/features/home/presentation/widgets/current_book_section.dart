import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:reading_app/features/home/presentation/widgets/current_book_card.dart';
import 'package:reading_app/core/animations/widget_animations.dart';

class CurrentBookSection extends StatelessWidget {
  const CurrentBookSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) {
        // Solo reconstruir si cambia el currentBookId (mostrar/ocultar tarjeta)
        return current.when(
          initial: () => false,
          loading: () => false,
          deleted: () => false,
          loaded: (profile) {
            return previous.when(
              initial: () => true,
              loading: () => true,
              deleted: () => true,
              loaded: (prevProfile) {
                // Solo reconstruir si cambia de null a valor o de valor a null
                final prevHasBook =
                    prevProfile.currentBookId != null &&
                    prevProfile.currentBookId!.isNotEmpty;
                final currHasBook =
                    profile.currentBookId != null &&
                    profile.currentBookId!.isNotEmpty;
                final shouldRebuild = prevHasBook != currHasBook;
                return shouldRebuild;
              },
              error: (_) => true,
            );
          },
          error: (_) => false,
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          deleted: () => const SizedBox.shrink(),
          loaded: (profile) {
            // Solo mostrar si hay un libro actual válido
            if (profile.currentBookId == null ||
                profile.currentBookId!.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                SlideInWidget(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: CurrentBookCard(profile: profile),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
          error: (_) => const SizedBox.shrink(),
        );
      },
    );
  }
}
