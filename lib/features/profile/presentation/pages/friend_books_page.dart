import 'package:flutter/material.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/profile/domain/usecases/get_user_profile.dart';
import 'package:reading_app/features/books/data/datasources/google_books_api.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/presentation/pages/book_detail_page.dart';

class FriendBooksPage extends StatefulWidget {
  final String friendId;
  final String friendDisplayName;

  const FriendBooksPage({
    super.key,
    required this.friendId,
    required this.friendDisplayName,
  });

  @override
  State<FriendBooksPage> createState() => _FriendBooksPageState();
}

class _FriendBooksPageState extends State<FriendBooksPage>
    with SingleTickerProviderStateMixin {
  final _getUserProfile = getIt<GetUserProfile>();
  final _googleBooksApi = getIt<GoogleBooksApi>();

  late TabController _tabController;
  UserProfile? _profile;
  bool _isLoading = true;

  List<Book> _favoriteBooks = [];
  List<Book> _readBooks = [];
  bool _loadingFavorites = false;
  bool _loadingRead = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _getUserProfile(widget.friendId);
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
      _loadFavorites();
      _loadReadBooks();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _loadFavorites() async {
    if (_profile?.favoriteBookIds == null ||
        _profile!.favoriteBookIds!.isEmpty) {
      return;
    }

    setState(() => _loadingFavorites = true);
    final books = <Book>[];
    for (final bookId in _profile!.favoriteBookIds!) {
      try {
        final book = await _googleBooksApi.getBookById(bookId);
        if (book != null) {
          books.add(book);
        }
      } catch (e) {
        // Skip books that fail to load
      }
    }
    setState(() {
      _favoriteBooks = books;
      _loadingFavorites = false;
    });
  }

  Future<void> _loadReadBooks() async {
    if (_profile?.completedBookIds == null ||
        _profile!.completedBookIds!.isEmpty) {
      return;
    }

    setState(() => _loadingRead = true);
    final books = <Book>[];
    for (final bookId in _profile!.completedBookIds!) {
      try {
        final book = await _googleBooksApi.getBookById(bookId);
        if (book != null) {
          books.add(book);
        }
      } catch (e) {
        // Skip books that fail to load
      }
    }
    setState(() {
      _readBooks = books;
      _loadingRead = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Libros de @${widget.friendDisplayName}'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favoritos', icon: Icon(Icons.favorite)),
            Tab(text: 'Leídos', icon: Icon(Icons.book)),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildBooksList(
                    _favoriteBooks,
                    _loadingFavorites,
                    'favoritos',
                  ),
                  _buildBooksList(_readBooks, _loadingRead, 'leídos'),
                ],
              ),
    );
  }

  Widget _buildBooksList(List<Book> books, bool loading, String type) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'favoritos' ? Icons.favorite_border : Icons.book_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay libros $type',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          child: ListTile(
            leading:
                book.thumbnail != null
                    ? Hero(
                      tag: 'book-${book.id}',
                      child: Image.network(
                        book.thumbnail!,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.book),
                      ),
                    )
                    : const Icon(Icons.book),
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              book.authors.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(book: book),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
