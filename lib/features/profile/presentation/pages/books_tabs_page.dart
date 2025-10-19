import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:reading_app/features/profile/presentation/widgets/book_list_widget.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/domain/entities/book_ficha.dart';
import 'package:reading_app/features/books/domain/repositories/book_ficha_repository.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';

class BooksTabsPage extends StatelessWidget {
  const BooksTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Libros'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Favoritos'),
              Tab(icon: Icon(Icons.book), text: 'Leídos'),
            ],
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded:
                  (profile) => SafeArea(
                    child: TabBarView(
                      children: [
                        // FAVORITOS
                        BookListWidget(
                          bookIds: profile.favoriteBookIds ?? [],
                          title: 'Mis Libros Favoritos',
                          emptyMessage: 'No tienes libros favoritos aún',
                          emptySubtitle: 'Busca libros y añádelos a favoritos',
                          emptyIcon: Icons.favorite_border,
                          trailingWidget:
                              (book) =>
                                  const Icon(Icons.favorite, color: Colors.red),
                          onTrailingTap: null,
                        ),
                        // LEÍDOS
                        (profile.completedBookIds?.isNotEmpty == true)
                            ? BookListWidget(
                              bookIds: profile.completedBookIds!,
                              title: 'Mis Libros Leídos',
                              emptyMessage: 'No tienes libros leídos aún',
                              emptySubtitle:
                                  'Marca libros como leídos para verlos aquí',
                              emptyIcon: Icons.book,
                              trailingWidget:
                                  (book) => _buildFichaButton(context, book),
                              onTrailingTap:
                                  (book) => _navigateToFicha(context, book),
                            )
                            : const Center(
                              child: Text('No tienes libros leídos.'),
                            ),
                      ],
                    ),
                  ),
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}

// Método auxiliar para construir el icono de ficha
Widget _buildFichaButton(BuildContext context, Book book) {
  return FutureBuilder<BookFicha?>(
    future: _getBookFichaForUserAndBook(context, book.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      }

      final hasFicha = snapshot.hasData && snapshot.data != null;
      return Icon(hasFicha ? Icons.edit_note : Icons.assignment_add);
    },
  );
}

// Método auxiliar para navegar a la ficha
VoidCallback _navigateToFicha(BuildContext context, Book book) => () {
  Navigator.of(context).pushNamed('/book-ficha-form', arguments: book);
};

// Método auxiliar para obtener la ficha del libro
Future<BookFicha?> _getBookFichaForUserAndBook(
  BuildContext context,
  String bookId,
) async {
  final authState = context.read<AuthBloc>().state;
  String? userId;
  authState.whenOrNull(authenticated: (user) => userId = user.uid);

  if (userId != null) {
    final bookFichaRepository = getIt<BookFichaRepository>();
    return await bookFichaRepository.getBookFichaForUserAndBook(
      userId!,
      bookId,
    );
  }
  return null;
}
