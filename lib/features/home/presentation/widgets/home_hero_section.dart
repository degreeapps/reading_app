import 'package:flutter/material.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';

class HomeHeroSection extends StatelessWidget {
  final UserProfile profile;

  const HomeHeroSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navegar a la página de pestañas de favoritos/leídos
          Navigator.of(context).pushNamed('/books-tabs');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Navegar a la página de perfil
                  Navigator.of(context).pushNamed('/profile');
                },
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.2),
                  backgroundImage:
                      profile.photoURL != null
                          ? NetworkImage(profile.photoURL!)
                          : null,
                  child:
                      profile.photoURL == null
                          ? Icon(
                            Icons.person,
                            size: 35,
                            color: Theme.of(context).primaryColor,
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 16),

              // Información del usuario
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saludo personalizado
                    Text(
                      _getGreeting(),
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Estado actual
                    const SizedBox(height: 8),
                    _buildCurrentStatus(context),
                  ],
                ),
              ),

              // Indicador de que es clickeable
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final greeting =
        hour < 12
            ? '¡Buenos días'
            : hour < 18
            ? '¡Buenas tardes'
            : '¡Buenas noches';

    // Usar el nombre real del usuario si está disponible
    final userName =
        profile.firstName?.isNotEmpty == true
            ? profile.firstName!
            : profile.displayName;

    return '$greeting, $userName!';
  }

  Widget _buildCurrentStatus(BuildContext context) {
    if (profile.currentBookId != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.book, size: 16, color: Colors.green[700]),
            const SizedBox(width: 6),
            Text(
              'Leyendo un libro',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 16, color: Colors.orange[700]),
            const SizedBox(width: 6),
            Text(
              '¡Busca tu próximo libro!',
              style: TextStyle(
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
  }
}
