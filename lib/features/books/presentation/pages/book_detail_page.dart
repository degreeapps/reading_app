import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:reading_app/features/books/domain/entities/book_ficha.dart'; // Nuevo import
import 'package:reading_app/features/books/domain/repositories/book_ficha_repository.dart'; // Nuevo import
import 'package:reading_app/core/config/injection.dart'; // Nuevo import

class BookDetailPage extends StatelessWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Libro'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: 'book-${book.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        book.thumbnail != null
                            ? Image.network(
                              book.thumbnail!,
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Icon(Icons.book, size: 100),
                            )
                            : const Icon(Icons.book, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                book.authors.isNotEmpty
                    ? book.authors.join(', ')
                    : 'Autor desconocido',
                style: const TextStyle(fontSize: 18, color: Colors.brown),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (book.categories != null && book.categories!.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children:
                      book.categories!
                          .map(
                            (cat) => Chip(
                              label: Text(cat),
                              backgroundColor: Colors.amber[100],
                            ),
                          )
                          .toList(),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, color: Colors.orange),
                  const SizedBox(width: 6),
                  Text(
                    '${book.pageCount ?? '-'} páginas',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.language, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    book.language?.toUpperCase() ?? '-',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (book.description != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    book.description!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              const SizedBox(height: 32),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  final isFavorite = profileState.maybeWhen(
                    loaded:
                        (profile) =>
                            profile.favoriteBookIds?.contains(book.id) ?? false,
                    orElse: () => false,
                  );

                  final isCurrentBook = profileState.maybeWhen(
                    loaded: (profile) => profile.currentBookId == book.id,
                    orElse: () => false,
                  );

                  final isCompleted = profileState.maybeWhen(
                    loaded:
                        (profile) =>
                            profile.completedBookIds?.contains(book.id) ??
                            false,
                    orElse: () => false,
                  );

                  return Column(
                    children: [
                      // Botón "Leer ahora" - solo mostrar si no es el libro actual
                      if (!isCurrentBook)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final authState = context.read<AuthBloc>().state;
                              authState.when(
                                authenticated: (user) {
                                  // Verificar si ya existe un libro actual
                                  final hasCurrentBook = profileState.maybeWhen(
                                    loaded:
                                        (profile) =>
                                            profile.currentBookId != null &&
                                            profile.currentBookId!.isNotEmpty,
                                    orElse: () => false,
                                  );

                                  if (hasCurrentBook) {
                                    // Mostrar diálogo de confirmación
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Reemplazar libro actual',
                                          ),
                                          content: const Text(
                                            'Ya tienes un libro en lectura actual. ¿Quieres reemplazarlo con este libro?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.of(
                                                        context,
                                                      ).pop(),
                                              child: const Text('Cancelar'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                context.read<ProfileBloc>().add(
                                                  ProfileEvent.setCurrentBook(
                                                    user.uid,
                                                    book.id,
                                                    0, // Progreso inicial
                                                  ),
                                                );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Libro establecido como lectura actual',
                                                    ),
                                                    backgroundColor:
                                                        Colors.blue,
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text('Reemplazar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    // No hay libro actual, establecer directamente
                                    context.read<ProfileBloc>().add(
                                      ProfileEvent.setCurrentBook(
                                        user.uid,
                                        book.id,
                                        0, // Progreso inicial
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Libro establecido como lectura actual',
                                        ),
                                        backgroundColor: Colors.blue,
                                      ),
                                    );
                                  }
                                },
                                initial: () {},
                                loading: () {},
                                unauthenticated: () {},
                                error: (message) {},
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Leer ahora'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Botón 'Marcar como favorito'
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final authState = context.read<AuthBloc>().state;
                            authState.when(
                              authenticated: (user) {
                                if (isFavorite) {
                                  // Quitar de favoritos
                                  context.read<ProfileBloc>().add(
                                    ProfileEvent.removeBookFromFavorites(
                                      user.uid,
                                      book.id,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Libro quitado de favoritos',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                } else {
                                  // Añadir a favoritos
                                  context.read<ProfileBloc>().add(
                                    ProfileEvent.addBookToFavorites(
                                      user.uid,
                                      book.id,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Libro añadido a favoritos',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
                              initial: () {},
                              loading: () {},
                              unauthenticated: () {},
                              error: (message) {},
                            );
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          label: Text(
                            isFavorite
                                ? 'Quitar de favoritos'
                                : 'Marcar como favorito',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor:
                                isFavorite ? Colors.red : Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Botón 'Marcar como leído'
                      if (!isCompleted)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final authState = context.read<AuthBloc>().state;
                              authState.when(
                                authenticated: (user) {
                                  context.read<ProfileBloc>().add(
                                    ProfileEvent.markBookAsFinished(
                                      user.uid,
                                      book.id,
                                    ),
                                  );

                                  // Mostrar diálogo para rellenar la ficha
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Felicidades, libro terminado!',
                                        ),
                                        content: Text(
                                          '¿Te gustaría rellenar la ficha de "${book.title}" ahora?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(
                                                context,
                                              ).pop(); // Cerrar el diálogo
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '¡Felicidades! Has terminado "${book.title}"',
                                                  ),
                                                  backgroundColor: Colors.green,
                                                  duration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('No, gracias'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(
                                                context,
                                              ).pop(); // Cerrar el diálogo
                                              Navigator.of(context).pushNamed(
                                                '/book-ficha-form',
                                                arguments: book,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text(
                                              'Sí, rellenar ficha',
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                initial: () {},
                                loading: () {},
                                unauthenticated: () {},
                                error: (message) {},
                              );
                            },
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Marcar como leído'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 16,
                      ), // Espacio adicional para el botón de ficha
                      // Botón 'Ver/Crear Ficha' - solo si el libro está completado
                      if (isCompleted)
                        FutureBuilder<BookFicha?>(
                          // TODO: Importar BookFicha
                          future: _getBookFichaForUserAndBook(
                            context,
                            book.id,
                          ), // TODO: Implementar _getBookFichaForUserAndBook
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final hasFicha =
                                snapshot.hasData && snapshot.data != null;
                            return SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    '/book-ficha-form',
                                    arguments: book, // Siempre pasamos el libro
                                  );
                                },
                                icon: Icon(
                                  hasFicha
                                      ? Icons.edit_note
                                      : Icons.assignment_add,
                                ),
                                label: Text(
                                  hasFicha ? 'Ver/Editar Ficha' : 'Crear Ficha',
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Nuevo método para obtener la ficha del libro
  Future<BookFicha?> _getBookFichaForUserAndBook(
    BuildContext context,
    String bookId,
  ) async {
    final authState = context.read<AuthBloc>().state;
    String? userId;
    authState.whenOrNull(authenticated: (user) => userId = user.uid);

    if (userId != null) {
      final bookFichaRepository =
          getIt<
            BookFichaRepository
          >(); // TODO: Importar getIt y BookFichaRepository
      return await bookFichaRepository.getBookFichaForUserAndBook(
        userId!,
        bookId,
      );
    }
    return null;
  }
}
