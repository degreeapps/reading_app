import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/books/presentation/bloc/book_bloc.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/presentation/pages/book_detail_page.dart';

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Limpiar búsqueda anterior al entrar a la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('DEBUG: Clearing search results on page init');
      context.read<BookBloc>().add(const BookEvent.clear());
      // También limpiar el controlador de texto
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      context.read<BookBloc>().add(BookEvent.search(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Libros'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _onSearch(),
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: '¿Qué libro quieres buscar?',
                  prefixIcon: const Icon(Icons.search, size: 28),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      context.read<BookBloc>().add(const BookEvent.clear());
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<BookBloc, BookState>(
                builder: (context, state) {
                  return state.when(
                    initial:
                        () => const Center(
                          child: Text(
                            '¡Busca tu próximo libro favorito! 📚',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    loaded:
                        (books) =>
                            books.isEmpty
                                ? const Center(
                                  child: Text(
                                    'No se encontraron libros. Prueba con otro título o autor.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                                : ListView.separated(
                                  itemCount: books.length,
                                  separatorBuilder:
                                      (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final book = books[index];
                                    return _BookCard(book: book);
                                  },
                                ),
                    error:
                        (msg) => Center(
                          child: Text(
                            'Ocurrió un error: $msg',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.amber[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    book.thumbnail != null
                        ? Image.network(
                          book.thumbnail!,
                          width: 60,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(Icons.book, size: 60),
                        )
                        : const Icon(Icons.book, size: 60),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.authors.isNotEmpty
                          ? book.authors.join(', ')
                          : 'Autor desconocido',
                      style: const TextStyle(fontSize: 15, color: Colors.brown),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.menu_book,
                          size: 18,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${book.pageCount ?? '-'} páginas',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
