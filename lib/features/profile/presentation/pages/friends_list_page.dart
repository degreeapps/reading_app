import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_app/core/animations/page_transitions.dart';
import 'package:reading_app/core/animations/widget_animations.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/profile/domain/usecases/get_friends.dart';
import 'package:reading_app/features/profile/domain/usecases/remove_friend.dart';
import 'package:reading_app/features/profile/presentation/pages/friend_profile_page.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final _getFriends = getIt<GetFriends>();
  final _removeFriend = getIt<RemoveFriend>();

  List<Map<String, dynamic>> _friends = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    authState.whenOrNull(
      authenticated: (user) {
        _currentUserId = user.uid;
        _loadFriends();
      },
    );
  }

  Future<void> _loadFriends() async {
    if (_currentUserId == null) return;

    setState(() => _isLoading = true);
    try {
      final friendIds = await _getFriends(_currentUserId!);

      // Load friend profiles
      final friendProfiles = <Map<String, dynamic>>[];
      for (final friendId in friendIds) {
        final doc =
            await FirebaseFirestore.instance
                .collection('user_profiles')
                .doc(friendId)
                .get();
        if (doc.exists) {
          friendProfiles.add(doc.data()!);
        }
      }

      setState(() {
        _friends = friendProfiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _showRemoveFriendDialog(Map<String, dynamic> friend) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar amigo'),
          content: Text(
            '¿Estás seguro de que quieres eliminar a @${friend['displayName']} de tus amigos?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && _currentUserId != null) {
      try {
        await _removeFriend(_currentUserId!, friend['uid']);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Amigo eliminado')));
          _loadFriends(); // Reload the list
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Amigos'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _loadFriends,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _friends.isEmpty
                ? ListView(
                  // Wrap in ListView to make RefreshIndicator work
                  children: const [
                    SizedBox(height: 200),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Aún no tienes amigos',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Busca usuarios y envía invitaciones',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  itemCount: _friends.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final friend = _friends[index];
                    return FadeInSlideWidget(
                      delay: Duration(milliseconds: 50 * index),
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Hero(
                            tag: 'friend_avatar_${friend['uid']}',
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              child: Text(
                                (friend['displayName'] ?? 'U')[0].toUpperCase(),
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                          title: Text('@${friend['displayName'] ?? ''}'),
                          subtitle: Text(friend['firstName'] ?? ''),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'remove') {
                                _showRemoveFriendDialog(friend);
                              }
                            },
                            itemBuilder:
                                (BuildContext context) => [
                                  const PopupMenuItem<String>(
                                    value: 'remove',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_remove,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Eliminar amigo',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              SlideRightTransition(
                                page: FriendProfilePage(
                                  friendId: friend['uid'],
                                  friendDisplayName:
                                      friend['displayName'] ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
