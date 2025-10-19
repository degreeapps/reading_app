import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/core/animations/widget_animations.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/profile/domain/usecases/check_friendship_status.dart';
import 'package:reading_app/features/profile/domain/usecases/send_friend_request.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  final _sendFriendRequest = getIt<SendFriendRequest>();
  final _checkFriendshipStatus = getIt<CheckFriendshipStatus>();
  String? _currentUserId;
  final Set<String> _sendingRequests = {};

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    authState.whenOrNull(
      authenticated: (user) {
        _currentUserId = user.uid;
      },
    );
  }

  Future<void> _searchUsers() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('user_profiles')
              .where('displayName', isGreaterThanOrEqualTo: query)
              .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
              .limit(20)
              .get();
      setState(() {
        _results = snapshot.docs
            .map((doc) => doc.data())
            .where((user) => user['uid'] != _currentUserId) // Exclude current user
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _sendRequest(Map<String, dynamic> targetUser) async {
    if (_currentUserId == null) return;
    if (_sendingRequests.contains(targetUser['uid'])) return;

    setState(() => _sendingRequests.add(targetUser['uid']));

    try {
      final authState = context.read<AuthBloc>().state;
      String currentDisplayName = '';
      authState.whenOrNull(
        authenticated: (user) {
          currentDisplayName = user.displayName ?? user.email;
        },
      );

      await _sendFriendRequest(
        fromUserId: _currentUserId!,
        toUserId: targetUser['uid'],
        fromUserDisplayName: currentDisplayName,
        toUserDisplayName: targetUser['displayName'] ?? '',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.send, color: Colors.white),
                SizedBox(width: 8),
                Text('Invitación enviada'),
              ],
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() => _sendingRequests.remove(targetUser['uid'])); // Refresh to update button state
      }
    } catch (e) {
      setState(() => _sendingRequests.remove(targetUser['uid']));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar usuarios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de usuario',
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchUsers(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchUsers,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!_isLoading &&
                _results.isEmpty &&
                _searchController.text.isNotEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No se encontraron usuarios',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            if (!_isLoading && _results.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _searchUsers,
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final user = _results[index];
                      return FutureBuilder<FriendshipStatus>(
                        future: _currentUserId != null
                            ? _checkFriendshipStatus(_currentUserId!, user['uid'])
                            : Future.value(FriendshipStatus.none),
                        builder: (context, snapshot) {
                          final status = snapshot.data ?? FriendshipStatus.none;
                          final isSending = _sendingRequests.contains(user['uid']);
                          
                          return FadeInSlideWidget(
                            delay: Duration(milliseconds: 50 * index),
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiaryContainer,
                                  child: Text(
                                    (user['displayName'] ?? 'U')[0].toUpperCase(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer,
                                    ),
                                  ),
                                ),
                                title: Text('@${user['displayName'] ?? ''}'),
                                subtitle: Text(user['firstName'] ?? ''),
                                trailing: _buildActionButton(user, status, isSending),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    Map<String, dynamic> user,
    FriendshipStatus status,
    bool isSending,
  ) {
    if (isSending) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    switch (status) {
      case FriendshipStatus.friends:
        return Chip(
          label: const Text('Amigos'),
          avatar: const Icon(Icons.check_circle, size: 16),
          backgroundColor: Colors.green[100],
          labelStyle: TextStyle(color: Colors.green[800]),
        );
      case FriendshipStatus.requestSent:
        return Chip(
          label: const Text('Enviada'),
          avatar: const Icon(Icons.schedule, size: 16),
          backgroundColor: Colors.orange[100],
          labelStyle: TextStyle(color: Colors.orange[800]),
        );
      case FriendshipStatus.requestReceived:
        return Chip(
          label: const Text('Pendiente'),
          avatar: const Icon(Icons.mail, size: 16),
          backgroundColor: Colors.blue[100],
          labelStyle: TextStyle(color: Colors.blue[800]),
        );
      case FriendshipStatus.none:
        return ElevatedButton.icon(
          onPressed: () => _sendRequest(user),
          icon: const Icon(Icons.person_add, size: 18),
          label: const Text('Agregar'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        );
    }
  }
}
