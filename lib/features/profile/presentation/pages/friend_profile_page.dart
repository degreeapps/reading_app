import 'package:flutter/material.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/profile/domain/usecases/get_user_profile.dart';
import 'package:reading_app/features/profile/domain/usecases/get_friends.dart';
import 'package:reading_app/features/profile/presentation/pages/friend_books_page.dart';
import 'package:reading_app/features/books/data/datasources/google_books_api.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/presentation/pages/book_detail_page.dart';

class FriendProfilePage extends StatefulWidget {
  final String friendId;
  final String friendDisplayName;

  const FriendProfilePage({
    super.key,
    required this.friendId,
    required this.friendDisplayName,
  });

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  final _getUserProfile = getIt<GetUserProfile>();
  final _getFriends = getIt<GetFriends>();
  final _googleBooksApi = getIt<GoogleBooksApi>();

  UserProfile? _profile;
  int _friendsCount = 0;
  bool _isLoading = true;
  Book? _currentBook;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _getUserProfile(widget.friendId);
      final friends = await _getFriends(widget.friendId);

      setState(() {
        _profile = profile;
        _friendsCount = friends.length;
        _isLoading = false;
      });

      // Load current book if exists
      if (profile?.currentBookId != null) {
        _loadCurrentBook(profile!.currentBookId!);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _loadCurrentBook(String bookId) async {
    try {
      final book = await _googleBooksApi.getBookById(bookId);
      setState(() {
        _currentBook = book;
      });
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('@${widget.friendDisplayName}'),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _profile == null
              ? const Center(child: Text('No se pudo cargar el perfil'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => FriendBooksPage(
                                    friendId: widget.friendId,
                                    friendDisplayName: widget.friendDisplayName,
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    _profile!.photoURL != null
                                        ? NetworkImage(_profile!.photoURL!)
                                        : null,
                                child:
                                    _profile!.photoURL == null
                                        ? const Icon(Icons.person, size: 40)
                                        : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _profile!.firstName?.isNotEmpty == true
                                          ? _profile!.firstName!
                                          : _profile!.displayName,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '@${_profile!.displayName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey[700]),
                                    ),
                                    if (_profile!.age != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_profile!.age} años',
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
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  'Favoritos',
                                  '${_profile!.favoriteBookIds?.length ?? 0}',
                                  Icons.favorite,
                                ),
                                _buildStatItem(
                                  'Leídos',
                                  '${_profile!.totalBooksRead ?? 0}',
                                  Icons.book,
                                ),
                                _buildStatItem(
                                  'Amigos',
                                  '$_friendsCount',
                                  Icons.people,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Current Reading (if any)
                    if (_profile!.currentBookId != null) ...[
                      Card(
                        child: InkWell(
                          onTap:
                              _currentBook != null
                                  ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BookDetailPage(
                                              book: _currentBook!,
                                            ),
                                      ),
                                    );
                                  }
                                  : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Leyendo actualmente',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 12),
                                if (_currentBook != null) ...[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_currentBook!.thumbnail != null)
                                        Hero(
                                          tag: 'book-${_currentBook!.id}',
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: Image.network(
                                              _currentBook!.thumbnail!,
                                              width: 60,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.book,
                                                    size: 60,
                                                  ),
                                            ),
                                          ),
                                        )
                                      else
                                        const Icon(Icons.book, size: 60),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _currentBook!.title,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _currentBook!.authors.join(', '),
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Progreso: ${_profile!.currentBookProgress ?? 0}%',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                            ),
                                            const SizedBox(height: 4),
                                            LinearProgressIndicator(
                                              value:
                                                  (_profile!
                                                          .currentBookProgress ??
                                                      0) /
                                                  100,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  Row(
                                    children: [
                                      const Icon(Icons.menu_book, size: 32),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Progreso: ${_profile!.currentBookProgress ?? 0}%',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge,
                                            ),
                                            const SizedBox(height: 4),
                                            LinearProgressIndicator(
                                              value:
                                                  (_profile!
                                                          .currentBookProgress ??
                                                      0) /
                                                  100,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Favorite Genres
                    if (_profile!.favoriteGenres?.isNotEmpty == true) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Géneros favoritos',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children:
                                    _profile!.favoriteGenres!
                                        .map(
                                          (genre) => Chip(
                                            label: Text(genre),
                                            avatar: const Icon(
                                              Icons.label,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
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
  }
}
