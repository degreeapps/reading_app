import 'package:flutter/material.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/presentation/pages/book_detail_page.dart';
import 'package:reading_app/features/books/data/datasources/google_books_api.dart';
import 'package:reading_app/core/animations/widget_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesPreviewCard extends StatelessWidget {
  final List<String> bookIds;

  const FavoritesPreviewCard({super.key, required this.bookIds});

  @override
  Widget build(BuildContext context) {
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
              Colors.pink.withValues(alpha: 0.1),
              Colors.purple.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.pink[700], size: 24),
                const SizedBox(width: 8),
                Text(
                  'Mis Libros Favoritos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[700],
                  ),
                ),
                const Spacer(),
                Text(
                  '${bookIds.length} libros',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Vista previa de libros
            if (bookIds.isNotEmpty) ...[
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bookIds.length > 5 ? 5 : bookIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<Book>(
                      future: _loadBookDetails(bookIds[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingPreview(context);
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return _buildErrorPreview(context, bookIds[index]);
                        }

                        return _buildBookPreview(context, snapshot.data!);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Botón para ver todos
              if (bookIds.length > 5)
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Navegar a la lista completa de favoritos
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: Text('Ver todos los ${bookIds.length} libros'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.pink[700],
                      side: BorderSide(color: Colors.pink[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ] else ...[
              // Estado vacío
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 32, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'No tienes libros favoritos',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
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

  Widget _buildBookPreview(BuildContext context, Book book) {
    return AnimatedCard(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
          );
        },
        child: Container(
          width: 80,
          margin: const EdgeInsets.only(right: 12),
          child: Column(
            children: [
              // Thumbnail del libro
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: _getBookColor(book.id),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    book.thumbnail != null && book.thumbnail!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: book.thumbnail!,
                            width: 80,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  width: 80,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    _buildPlaceholder(book),
                          ),
                        )
                        : _buildPlaceholder(book),
              ),
              const SizedBox(height: 4),
              // Título del libro
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingPreview(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 60,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPreview(BuildContext context, String bookId) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!, width: 1),
            ),
            child: const Icon(Icons.error, size: 30, color: Colors.red),
          ),
          const SizedBox(height: 4),
          Text(
            'Error',
            style: TextStyle(fontSize: 10, color: Colors.red[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<Book> _loadBookDetails(String bookId) async {
    try {
      // Usar la API real de Google Books
      final api = GoogleBooksApi();
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

  Widget _buildPlaceholder(Book book) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: _getBookColor(book.id),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 30, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              book.title.split(' ').take(2).join(' '),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
