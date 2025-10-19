import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:reading_app/features/home/presentation/widgets/home_hero_section.dart';
import 'package:reading_app/features/home/presentation/widgets/current_book_section.dart';

import 'package:reading_app/features/home/presentation/widgets/favorites_preview_card.dart';
import 'package:reading_app/features/profile/presentation/pages/profile_page.dart';
import 'package:reading_app/features/books/presentation/pages/book_search_page.dart';
import 'package:reading_app/core/animations/widget_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load profile when page is opened
    final authState = context.read<AuthBloc>().state;
    authState.when(
      authenticated: (user) {
        context.read<ProfileBloc>().add(ProfileEvent.loadProfile(user.uid));
      },
      initial: () {},
      loading: () {},
      unauthenticated: () {},
      error: (message) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Biblioteca'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookSearchPage()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.search),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) {
          // Solo reconstruir si cambian datos que no son del libro actual
          return current.when(
            initial: () => true,
            loading: () => true,
            deleted: () => true,
            loaded: (profile) {
              return previous.when(
                initial: () => true,
                loading: () => true,
                deleted: () => true,
                loaded:
                    (prevProfile) =>
                        prevProfile.displayName != profile.displayName ||
                        prevProfile.favoriteBookIds !=
                            profile.favoriteBookIds ||
                        prevProfile.totalBooksRead != profile.totalBooksRead,
                error: (_) => true,
              );
            },
            error: (_) => true,
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            deleted: () => const Center(child: CircularProgressIndicator()),
            loaded: (profile) => _buildHomeContent(profile),
            error: (message) => _buildErrorContent(message),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent(profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section - Saludo y avatar (clickeable para ir al perfil)
          FadeInWidget(
            duration: const Duration(milliseconds: 600),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: HomeHeroSection(profile: profile),
            ),
          ),
          const SizedBox(height: 24),

          // Libro actual (sección optimizada con BlocBuilder específico)
          const CurrentBookSection(),

          // Vista previa de favoritos
          if (profile.favoriteBookIds?.isNotEmpty == true) ...[
            SlideInWidget(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
              child: FavoritesPreviewCard(bookIds: profile.favoriteBookIds!),
            ),
            const SizedBox(height: 24),
          ],

          // Sección de estadísticas
          FadeInWidget(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 600),
            child: _buildStatsSection(profile),
          ),
          const SizedBox(height: 24),

          // Sección de recomendaciones
          FadeInWidget(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 800),
            child: _buildRecommendationsSection(),
          ),

          // Espacio adicional al final
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error al cargar la página',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              authState.when(
                authenticated: (user) {
                  context.read<ProfileBloc>().add(
                    ProfileEvent.loadProfile(user.uid),
                  );
                },
                initial: () {},
                loading: () {},
                unauthenticated: () {},
                error: (message) {},
              );
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(profile) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withValues(alpha: 0.1),
              Colors.indigo.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue[700], size: 24),
                const SizedBox(width: 8),
                Text(
                  'Mis Estadísticas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.book,
                    label: 'Libros Leídos',
                    value: '${profile.totalBooksRead ?? 0}',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.favorite,
                    label: 'Favoritos',
                    value: '${profile.favoriteBookIds?.length ?? 0}',
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.trending_up,
                    label: 'Progreso',
                    value: '${profile.currentBookProgress ?? 0}%',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withValues(alpha: 0.1),
              Colors.deepPurple.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.purple[700], size: 24),
                const SizedBox(width: 8),
                Text(
                  'Recomendaciones',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Icon(Icons.auto_awesome, size: 32, color: Colors.purple[400]),
                  const SizedBox(height: 8),
                  Text(
                    '¡Descubre nuevos libros!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Basado en tus géneros favoritos',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navegar a búsqueda de libros
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Explorar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
