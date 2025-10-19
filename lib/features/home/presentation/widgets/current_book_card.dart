import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/data/datasources/google_books_api.dart';
import 'package:reading_app/features/books/presentation/pages/book_detail_page.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

void _showDeleteConfirmationDialog(BuildContext context, Book book) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar libro actual'),
        content: Text(
          '¿Estás seguro de que quieres eliminar "${book.title}" de tu lista de lectura actual?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearCurrentBook(context, book);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}

void _clearCurrentBook(BuildContext context, Book book) {
  final authState = context.read<AuthBloc>().state;
  authState.when(
    authenticated: (user) {
      // Limpiar libro actual
      context.read<ProfileBloc>().add(
        ProfileEvent.setCurrentBook(user.uid, '', 0),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Se ha eliminado "${book.title}" de tu lista de lectura actual',
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    },
    initial: () {},
    loading: () {},
    unauthenticated: () {},
    error: (message) {},
  );
}

class CurrentBookCard extends StatelessWidget {
  final UserProfile profile;

  const CurrentBookCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile.currentBookId == null || profile.currentBookId!.isEmpty) {
      return const SizedBox.shrink(); // No mostrar si no hay libro actual
    }

    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) {
        // Solo reconstruir si cambia el progreso del mismo libro
        return current.when(
          initial: () => false,
          loading: () => false,
          deleted: () => false,
          loaded: (currentProfile) {
            return previous.when(
              initial: () => false,
              loading: () => false,
              deleted: () => false,
              loaded: (prevProfile) {
                return prevProfile.currentBookId == profile.currentBookId &&
                    prevProfile.currentBookProgress !=
                        currentProfile.currentBookProgress;
              },
              error: (_) => false,
            );
          },
          error: (_) => false,
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => _buildCardWithProfile(context, profile),
          loading: () => _buildCardWithProfile(context, profile),
          deleted: () => _buildCardWithProfile(context, profile),
          loaded:
              (currentProfile) =>
                  _buildCardWithProfile(context, currentProfile),
          error: (_) => _buildCardWithProfile(context, profile),
        );
      },
    );
  }

  Widget _buildCardWithProfile(
    BuildContext context,
    UserProfile currentProfile,
  ) {
    return FutureBuilder<Book?>(
      key: ValueKey(
        currentProfile.currentBookId,
      ), // Forzar reconstrucción cuando cambia el bookId
      future: _loadBookDetails(currentProfile.currentBookId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard(context);
        }

        if (!snapshot.hasData) {
          return _buildErrorCard(context);
        }

        final book = snapshot.data!;
        return _buildBookCard(context, book, currentProfile);
      },
    );
  }

  Future<Book?> _loadBookDetails(String bookId) async {
    try {
      final api = GoogleBooksApi();
      return await api.getBookById(bookId);
    } catch (e) {
      return null;
    }
  }

  Widget _buildLoadingCard(BuildContext context) {
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
              Colors.blue.withValues(alpha: 0.1),
              Colors.purple.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.book,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Libro Actual',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
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
              Colors.red.withValues(alpha: 0.1),
              Colors.orange.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Error al cargar libro actual',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('No se pudo cargar la información del libro'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(
    BuildContext context,
    Book book,
    UserProfile currentProfile,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookDetailPage(book: book)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.withValues(alpha: 0.1),
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
                  Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Libro Actual',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed:
                        () => _showDeleteConfirmationDialog(context, book),
                    tooltip: 'Eliminar libro actual',
                    color: Colors.red[600],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contenido del libro
              Row(
                children: [
                  // Portada del libro
                  Hero(
                    tag: 'book-${book.id}',
                    child: Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            book.thumbnail != null && book.thumbnail!.isNotEmpty
                                ? CachedNetworkImage(
                                  imageUrl: book.thumbnail!,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                          _buildBookPlaceholder(book),
                                )
                                : _buildBookPlaceholder(book),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Información del libro
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.authors.isNotEmpty
                              ? book.authors.join(', ')
                              : 'Autor desconocido',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),

                        // Progreso de lectura
                        _buildProgressSection(context, book, currentProfile),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showProgressDialog(context, book),
                      icon: const Icon(Icons.edit),
                      label: const Text('Progreso'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _markAsFinished(context, book),
                      icon: const Icon(Icons.check),
                      label: const Text('Terminado'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green[700],
                        side: BorderSide(color: Colors.green[700]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookPlaceholder(Book book) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: _getBookColor(book.id),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 30, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              book.title.split(' ').take(2).join('\n'),
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

  Color _getBookColor(String bookId) {
    final colors = [
      Colors.red[400]!,
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.purple[400]!,
      Colors.orange[400]!,
      Colors.teal[400]!,
    ];
    final hash = bookId.hashCode;
    final index = hash.abs() % colors.length;
    return colors[index];
  }

  Widget _buildProgressSection(
    BuildContext context,
    Book book,
    UserProfile currentProfile,
  ) {
    final progress = currentProfile.currentBookProgress ?? 0;
    final totalPages = book.pageCount ?? 0;
    final currentPage =
        totalPages > 0 ? ((progress / 100) * totalPages).round() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              '$progress%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
          minHeight: 8,
        ),
        const SizedBox(height: 4),
        if (totalPages > 0)
          Text(
            'Página $currentPage de $totalPages',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          )
        else
          Text(
            'Libro en progreso',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
      ],
    );
  }

  void _showProgressDialog(BuildContext context, Book book) {
    final currentProgress = profile.currentBookProgress ?? 0;
    final totalPages = book.pageCount ?? 0;

    showDialog(
      context: context,
      builder:
          (context) => _ProgressUpdateDialog(
            book: book,
            currentProgress: currentProgress,
            totalPages: totalPages,
            onProgressUpdate: (newProgress) {
              final authState = context.read<AuthBloc>().state;
              authState.when(
                authenticated: (user) {
                  context.read<ProfileBloc>().add(
                    ProfileEvent.updateReadingProgress(user.uid, newProgress),
                  );
                },
                initial: () {},
                loading: () {},
                unauthenticated: () {},
                error: (message) {},
              );
            },
          ),
    );
  }

  void _markAsFinished(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.celebration, color: Colors.green),
                SizedBox(width: 8),
                Text('¡Felicidades!'),
              ],
            ),
            content: Text(
              '¿Has terminado de leer "${book.title}"?\n\nEsto marcará el libro como completado y se agregará a tu historial.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  final authState = context.read<AuthBloc>().state;
                  authState.when(
                    authenticated: (user) {
                      // Marcar como terminado y limpiar libro actual
                      context.read<ProfileBloc>().add(
                        ProfileEvent.markBookAsFinished(user.uid, book.id),
                      );

                      // Mostrar diálogo para rellenar la ficha
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Felicidades, libro terminado!'),
                            content: Text(
                              '¿Te gustaría rellenar la ficha de "${book.title}" ahora?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Cerrar el diálogo
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '¡Felicidades! Has terminado "${book.title}"',
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 3),
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
                                  // TODO: Navegar a la página de creación de ficha (Fase 2.3)
                                  Navigator.of(context).pushNamed(
                                    '/book-ficha-form',
                                    arguments: book,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Sí, rellenar ficha'),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Terminar libro'),
              ),
            ],
          ),
    );
  }
}

class _ProgressUpdateDialog extends StatefulWidget {
  final Book book;
  final int currentProgress;
  final int totalPages;
  final Function(int) onProgressUpdate;

  const _ProgressUpdateDialog({
    required this.book,
    required this.currentProgress,
    required this.totalPages,
    required this.onProgressUpdate,
  });

  @override
  State<_ProgressUpdateDialog> createState() => _ProgressUpdateDialogState();
}

class _ProgressUpdateDialogState extends State<_ProgressUpdateDialog> {
  late double _progress;
  late TextEditingController _pageController;
  bool _isPercentageMode = true;

  @override
  void initState() {
    super.initState();
    _progress = widget.currentProgress.toDouble();
    final currentPage =
        widget.totalPages > 0
            ? ((widget.currentProgress / 100) * widget.totalPages).round()
            : 0;
    _pageController = TextEditingController(text: currentPage.toString());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateProgressFromPage() {
    final page = int.tryParse(_pageController.text) ?? 0;
    if (widget.totalPages > 0 && page <= widget.totalPages) {
      setState(() {
        _progress = (page / widget.totalPages * 100).clamp(0, 100);
      });
    }
  }

  void _updatePageFromProgress() {
    final page =
        widget.totalPages > 0
            ? ((_progress / 100) * widget.totalPages).round()
            : 0;
    _pageController.text = page.toString();
  }

  @override
  void didUpdateWidget(covariant _ProgressUpdateDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentProgress != oldWidget.currentProgress) {
      _progress = widget.currentProgress.toDouble();
      _updatePageFromProgress(); // Also update page text if progress changes externally
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.trending_up, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          const Expanded(child: Text('Actualizar Progreso')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del libro
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child:
                          widget.book.thumbnail != null &&
                                  widget.book.thumbnail!.isNotEmpty
                              ? CachedNetworkImage(
                                imageUrl: widget.book.thumbnail!,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                        ),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) =>
                                        _buildBookPlaceholder(widget.book),
                              )
                              : _buildBookPlaceholder(widget.book),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.totalPages > 0)
                          Text(
                            '${widget.totalPages} páginas',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Modo de entrada
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isPercentageMode = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            _isPercentageMode
                                ? Theme.of(context).primaryColor
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Porcentaje',
                          style: TextStyle(
                            color:
                                _isPercentageMode
                                    ? Colors.white
                                    : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.totalPages > 0)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isPercentageMode = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              !_isPercentageMode
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Páginas',
                            style: TextStyle(
                              color:
                                  !_isPercentageMode
                                      ? Colors.white
                                      : Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            if (_isPercentageMode) ...[
              // Entrada por porcentaje
              Text(
                'Progreso: ${_progress.round()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: _progress,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${_progress.round()}%',
                onChanged: (value) {
                  setState(() {
                    _progress = value;
                    _updatePageFromProgress();
                  });
                },
              ),
            ] else if (widget.totalPages > 0) ...[
              // Entrada por páginas
              Text(
                'Página actual',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Página (de ${widget.totalPages})',
                  border: const OutlineInputBorder(),
                  suffixText: '/ ${widget.totalPages}',
                ),
                onChanged: (_) => _updateProgressFromPage(),
              ),
              const SizedBox(height: 8),
              Text(
                '${_progress.round()}% completado',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],

            const SizedBox(height: 24),

            // Botones de progreso rápido
            Text(
              'Progreso rápido',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _QuickProgressButton(
                  label: '25%',
                  value: 25,
                  isSelected: _progress == 25,
                  onTap: () {
                    setState(() {
                      _progress = 25;
                      _updatePageFromProgress();
                    });
                  },
                ),
                _QuickProgressButton(
                  label: '50%',
                  value: 50,
                  isSelected: _progress == 50,
                  onTap: () {
                    setState(() {
                      _progress = 50;
                      _updatePageFromProgress();
                    });
                  },
                ),
                _QuickProgressButton(
                  label: '75%',
                  value: 75,
                  isSelected: _progress == 75,
                  onTap: () {
                    setState(() {
                      _progress = 75;
                      _updatePageFromProgress();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onProgressUpdate(_progress.round());
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Progreso actualizado a ${_progress.round()}%'),
                backgroundColor: Colors.green,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Actualizar'),
        ),
      ],
    );
  }

  Widget _buildBookPlaceholder(Book book) {
    return Container(
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        color: _getBookColor(book.id),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 16, color: Colors.white),
            const SizedBox(height: 2),
            Text(
              book.title.split(' ').take(1).join(''),
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
    final colors = [
      Colors.red[400]!,
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.purple[400]!,
      Colors.orange[400]!,
      Colors.teal[400]!,
    ];
    final hash = bookId.hashCode;
    final index = hash.abs() % colors.length;
    return colors[index];
  }
}

class _QuickProgressButton extends StatelessWidget {
  final String label;
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickProgressButton({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[400]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
