import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/core/animations/page_transitions.dart';
import 'package:reading_app/core/widgets/app_version_label.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:reading_app/features/profile/presentation/widgets/profile_form.dart';
import 'package:reading_app/features/profile/presentation/widgets/change_password_dialog.dart';
import 'package:reading_app/features/profile/presentation/pages/user_search_page.dart';
import 'package:reading_app/features/profile/presentation/pages/friend_requests_page.dart';
import 'package:reading_app/features/profile/presentation/pages/friends_list_page.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/features/profile/domain/usecases/get_friends.dart';
import 'package:reading_app/features/profile/domain/usecases/get_friend_requests.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _getFriends = getIt<GetFriends>();
  final _getFriendRequests = getIt<GetFriendRequests>();
  int _friendsCount = 0;
  int _pendingRequestsCount = 0;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    // Load profile when page is opened
    final authState = context.read<AuthBloc>().state;
    authState.when(
      authenticated: (user) {
        _currentUserId = user.uid;
        context.read<ProfileBloc>().add(ProfileEvent.loadProfile(user.uid));
        _loadFriendsCount();
        _loadPendingRequestsCount();
      },
      initial: () {},
      loading: () {},
      unauthenticated: () {},
      error: (message) {},
    );
  }

  Future<void> _loadFriendsCount() async {
    if (_currentUserId == null) return;
    try {
      final friends = await _getFriends(_currentUserId!);
      setState(() {
        _friendsCount = friends.length;
      });
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> _loadPendingRequestsCount() async {
    if (_currentUserId == null) return;
    try {
      final requests = await _getFriendRequests(_currentUserId!);
      setState(() {
        _pendingRequestsCount = requests.length;
      });
    } catch (e) {
      // Silently fail
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.orange),
              SizedBox(width: 8),
              Text('Cerrar Sesión'),
            ],
          ),
          content: const Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                context.read<AuthBloc>().add(const AuthEvent.signOut());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        authState.whenOrNull(
          unauthenticated: () {
            // Usuario cerró sesión, navegar al login y limpiar stack
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_search),
              onPressed: () {
                Navigator.push(
                  context,
                  SlideUpTransition(page: const UserSearchPage()),
                );
              },
              tooltip: 'Buscar amigos',
            ),
            IconButton(
              icon: Badge(
                isLabelVisible: _pendingRequestsCount > 0,
                label: Text('$_pendingRequestsCount'),
                child: const Icon(Icons.mail),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  SlideUpTransition(page: const FriendRequestsPage()),
                ).then((_) {
                  _loadFriendsCount();
                  _loadPendingRequestsCount();
                });
              },
              tooltip: 'Invitaciones',
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _showLogoutDialog,
            ),
          ],
        ),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            state.whenOrNull(
              deleted: () {
                // Cuenta eliminada exitosamente, navegar al login y limpiar stack
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              error: (message) {
                // Mostrar error si falla la eliminación
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: Colors.red),
                );
              },
            );
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(child: Text('Cargando perfil...')),
                loading: () => const Center(child: CircularProgressIndicator()),
                deleted: () => const Center(child: CircularProgressIndicator()),
                loaded:
                    (profile) => SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Header
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        profile.photoURL != null
                                            ? NetworkImage(profile.photoURL!)
                                            : null,
                                    child:
                                        profile.photoURL == null
                                            ? const Icon(Icons.person, size: 40)
                                            : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile.firstName?.isNotEmpty == true
                                              ? profile.firstName!
                                              : profile.displayName,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.headlineSmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '@${profile.displayName}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        if (profile.age != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '${profile.age} años',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Statistics
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estadísticas',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStatItem(
                                        'Favoritos',
                                        '${profile.favoriteBookIds?.length ?? 0}',
                                        Icons.favorite,
                                        null,
                                      ),
                                      _buildStatItem(
                                        'Leídos',
                                        '${profile.totalBooksRead ?? 0}',
                                        Icons.book,
                                        null,
                                      ),
                                      _buildStatItem(
                                        'Amigos',
                                        '$_friendsCount',
                                        Icons.people,
                                        () {
                                          Navigator.push(
                                            context,
                                            SlideRightTransition(
                                              page: const FriendsListPage(),
                                            ),
                                          ).then((_) => _loadFriendsCount());
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Profile Form
                          ProfileForm(profile: profile),
                          const SizedBox(height: 16),

                          // Botón cambiar contraseña
                          Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.lock, color: Colors.white),
                              label: const Text(
                                'Cambiar contraseña',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => const ChangePasswordDialog(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Eliminar FavoritesList y cualquier referencia a libros favoritos o leídos en el perfil
                          // Mantener solo datos personales, estadísticas y formulario
                          // Botón eliminar cuenta
                          Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Eliminar cuenta',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                _showDeleteAccountDialog(context, profile.uid);
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Center(child: AppVersionLabel()),
                        ],
                      ),
                    ),
                error:
                    (message) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error al cargar el perfil',
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
                    ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    VoidCallback? onTap,
  ) {
    final statWidget = Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(padding: const EdgeInsets.all(8.0), child: statWidget),
      );
    }
    return statWidget;
  }

  void _showDeleteAccountDialog(BuildContext ctx, String uid) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Eliminar cuenta'),
            ],
          ),
          content: const Text(
            '¿Estás seguro? Esto borrará todos tus datos y no se puede deshacer.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ctx.read<ProfileBloc>().add(
                  ProfileEvent.deleteUserProfile(uid),
                );
              },
              child: const Text('Eliminar cuenta'),
            ),
          ],
        );
      },
    );
  }
}
