import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/core/animations/widget_animations.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/profile/domain/entities/friend_request.dart';
import 'package:reading_app/features/profile/domain/usecases/accept_friend_request.dart';
import 'package:reading_app/features/profile/domain/usecases/get_friend_requests.dart';
import 'package:reading_app/features/profile/domain/usecases/reject_friend_request.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  final _getFriendRequests = getIt<GetFriendRequests>();
  final _acceptFriendRequest = getIt<AcceptFriendRequest>();
  final _rejectFriendRequest = getIt<RejectFriendRequest>();

  List<FriendRequest> _requests = [];
  bool _isLoading = true;
  String? _currentUserId;
  final Set<String> _processingRequests = {};

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    authState.whenOrNull(
      authenticated: (user) {
        _currentUserId = user.uid;
        _loadRequests();
      },
    );
  }

  Future<void> _loadRequests() async {
    if (_currentUserId == null) return;

    setState(() => _isLoading = true);
    try {
      final requests = await _getFriendRequests(_currentUserId!);
      setState(() {
        _requests = requests;
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

  Future<void> _acceptRequest(FriendRequest request) async {
    if (_processingRequests.contains(request.id)) return;

    setState(() => _processingRequests.add(request.id));
    try {
      await _acceptFriendRequest(
        request.id,
        request.fromUserId,
        request.toUserId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Invitación aceptada'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() => _processingRequests.remove(request.id));
        _loadRequests(); // Reload the list
      }
    } catch (e) {
      setState(() => _processingRequests.remove(request.id));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _rejectRequest(FriendRequest request) async {
    if (_processingRequests.contains(request.id)) return;

    setState(() => _processingRequests.add(request.id));
    try {
      await _rejectFriendRequest(request.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.block, color: Colors.white),
                SizedBox(width: 8),
                Text('Invitación rechazada'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() => _processingRequests.remove(request.id));
        _loadRequests(); // Reload the list
      }
    } catch (e) {
      setState(() => _processingRequests.remove(request.id));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitaciones de amistad'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadRequests,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _requests.isEmpty
                ? ListView(
                  // Wrap in ListView to make RefreshIndicator work
                  children: const [
                    SizedBox(height: 200),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No tienes invitaciones pendientes',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  itemCount: _requests.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final request = _requests[index];
                    final isProcessing = _processingRequests.contains(
                      request.id,
                    );

                    return FadeInSlideWidget(
                      delay: Duration(milliseconds: 50 * index),
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                            child: Text(
                              request.fromUserDisplayName[0].toUpperCase(),
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                          title: Text('@${request.fromUserDisplayName}'),
                          subtitle: const Text(
                            'Te envió una invitación de amistad',
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing:
                              isProcessing
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                        onPressed:
                                            () => _acceptRequest(request),
                                        tooltip: 'Aceptar',
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _rejectRequest(request),
                                        tooltip: 'Rechazar',
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
