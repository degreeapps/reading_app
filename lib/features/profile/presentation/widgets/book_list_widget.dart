import 'package:flutter/material.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/presentation/pages/book_detail_page.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/features/books/data/datasources/google_books_api.dart';
import 'package:reading_app/core/animations/widget_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Widget reutilizable para mostrar listas de libros con funcionalidad parametrizable
class BookListWidget extends StatelessWidget {
  final List<String> bookIds;
  final String title;
  final String emptyMessage;
  final String emptySubtitle;
  final IconData emptyIcon;
  final Widget Function(Book book)? trailingWidget;
  final VoidCallback? Function(Book book)? onTrailingTap;
  final bool showCount;

  const BookListWidget({
    super.key,
    required this.bookIds,
    required this.title,
    required this.emptyMessage,
    required this.emptySubtitle,
    required this.emptyIcon,
    this.trailingWidget,
    this.onTrailingTap,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (showCount)
                Text(
                  '${bookIds.length} libros',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (bookIds.isEmpty)
            _buildEmptyState()
          else
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookIds.length,
                  itemBuilder: (context, index) {
                    final bookId = bookIds[index];
                    return FutureBuilder<Book>(
                      future: _loadBookDetails(bookId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Card(
                            child: ListTile(
                              leading: CircularProgressIndicator(),
                              title: Text('Cargando...'),
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              title: const Text('Error al cargar libro'),
                              subtitle: Text('ID: $bookId'),
                            ),
                          );
                        }

                        final book = snapshot.data!;
                        return _buildBookCard(context, book);
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(emptyIcon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Book book) {
    return AnimatedCard(
      child: Card(
        child: ListTile(
          leading: _buildBookThumbnail(book),
          title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            book.authors.join(', '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing:
              trailingWidget != null
                  ? (onTrailingTap != null
                      ? IconButton(
                        icon: trailingWidget!(book),
                        onPressed: onTrailingTap!(book),
                      )
                      : trailingWidget!(book))
                  : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailPage(book: book),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Book> _loadBookDetails(String bookId) async {
    try {
      final api = getIt<GoogleBooksApi>();
      final book = await api.getBookById(bookId);

      if (book != null) {
        return book;
      } else {
        // Fallback a datos por defecto si no se encuentra
        return Book(
          id: bookId,
          title: 'Libro $bookId',
          authors: ['Autor desconocido'],
          description: 'Descripción no disponible',
          thumbnail: null,
          pageCount: 0,
          language: 'es',
          categories: ['Sin categoría'],
        );
      }
    } catch (e) {
      // En caso de error, devolver un libro por defecto
      return Book(
        id: bookId,
        title: 'Libro $bookId',
        authors: ['Autor desconocido'],
        description: 'Error al cargar el libro',
        thumbnail: null,
        pageCount: 0,
        language: 'es',
        categories: ['Sin categoría'],
      );
    }
  }

  Widget _buildBookThumbnail(Book book) {
    return Hero(
      tag: 'book-${book.id}',
      child: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child:
            book.thumbnail != null && book.thumbnail!.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: book.thumbnail!,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => _buildPlaceholder(book),
                  ),
                )
                : _buildPlaceholder(book),
      ),
    );
  }

  Widget _buildPlaceholder(Book book) {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: _getBookColor(book.id),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 20, color: Colors.white),
            const SizedBox(height: 2),
            Text(
              book.title.split(' ').take(1).join(' '),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 6,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBookColor(String bookId) {
    // Generar un color basado en el hash del ID del libro para consistencia
    final colors = [
      Colors.red[400]!,
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.purple[400]!,
      Colors.orange[400]!,
      Colors.teal[400]!,
      Colors.indigo[400]!,
      Colors.pink[400]!,
      Colors.cyan[400]!,
      Colors.amber[400]!,
    ];

    // Usar el hash del ID para seleccionar un color de manera consistente
    final hash = bookId.hashCode;
    final index = hash.abs() % colors.length;
    return colors[index];
  }
}
