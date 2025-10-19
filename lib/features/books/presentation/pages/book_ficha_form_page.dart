import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/books/domain/entities/book_ficha.dart';
import 'package:uuid/uuid.dart';
import 'package:reading_app/features/books/domain/repositories/book_ficha_repository.dart';
import 'package:reading_app/core/config/injection.dart';

class BookFichaFormPage extends StatefulWidget {
  final Book book;
  const BookFichaFormPage({super.key, required this.book});

  @override
  State<BookFichaFormPage> createState() => _BookFichaFormPageState();
}

class _BookFichaFormPageState extends State<BookFichaFormPage> {
  final _formKey = GlobalKey<FormState>();
  BookFicha? _existingFicha;
  bool _loadingFicha = true;
  late int _rating;
  late TextEditingController _summaryController;
  late TextEditingController _learningsController;
  late TextEditingController _thoughtsController;
  bool _sharedWithTeachers = false;
  bool _sharedWithParents = false;

  @override
  void initState() {
    super.initState();
    _rating = 3;
    _summaryController = TextEditingController();
    _learningsController = TextEditingController();
    _thoughtsController = TextEditingController();
    _loadExistingFicha();
  }

  Future<void> _loadExistingFicha() async {
    final authState = context.read<AuthBloc>().state;
    String? userId;
    authState.whenOrNull(authenticated: (user) => userId = user.uid);
    if (userId != null) {
      final repo = getIt<BookFichaRepository>();
      final ficha = await repo.getBookFichaForUserAndBook(
        userId!,
        widget.book.id,
      );
      if (ficha != null) {
        setState(() {
          _existingFicha = ficha;
          _rating = ficha.rating;
          _summaryController.text = ficha.summary ?? '';
          _learningsController.text = ficha.learnings ?? '';
          _thoughtsController.text = ficha.thoughts ?? '';
          _sharedWithTeachers = ficha.sharedWithTeachers;
          _sharedWithParents = ficha.sharedWithParents;
          _loadingFicha = false;
        });
      } else {
        setState(() {
          _loadingFicha = false;
        });
      }
    } else {
      setState(() {
        _loadingFicha = false;
      });
    }
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _learningsController.dispose();
    _thoughtsController.dispose();
    super.dispose();
  }

  void _saveFicha() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      authState.maybeWhen(
        authenticated: (user) {
          if (user.uid.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Error: No se pudo obtener el ID de usuario. Intenta iniciar sesión de nuevo.',
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          final ficha = BookFicha(
            id: _existingFicha?.id ?? const Uuid().v4(),
            bookId: widget.book.id,
            userId: user.uid,
            rating: _rating,
            summary:
                _summaryController.text.isEmpty
                    ? null
                    : _summaryController.text,
            learnings:
                _learningsController.text.isEmpty
                    ? null
                    : _learningsController.text,
            thoughts:
                _thoughtsController.text.isEmpty
                    ? null
                    : _thoughtsController.text,
            sharedWithTeachers: _sharedWithTeachers,
            sharedWithParents: _sharedWithParents,
            createdAt: _existingFicha?.createdAt ?? DateTime.now(),
            updatedAt: DateTime.now(),
          );
          context.read<ProfileBloc>().add(ProfileEvent.saveBookFicha(ficha));
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ficha guardada con éxito!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        orElse: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Error: Debes iniciar sesión para guardar una ficha.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }

  Future<void> _deleteFicha() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('¿Borrar ficha?'),
            content: const Text(
              '¿Estás seguro de que deseas borrar esta ficha? Esta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Borrar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true && _existingFicha != null) {
      final authState = context.read<AuthBloc>().state;
      authState.whenOrNull(
        authenticated: (user) async {
          if (user.uid.isNotEmpty) {
            context.read<ProfileBloc>().add(
              ProfileEvent.deleteBookFicha(_existingFicha!.id, user.uid),
            );
            // Esperar un momento para que el bloc procese el evento y emita el nuevo estado
            // antes de cerrar la página. Esto asegura que la lista de libros leídos se refresque.
            await Future.delayed(const Duration(milliseconds: 100));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ficha borrada con éxito.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingFicha) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rellenar Ficha del Libro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del libro (pre-rellenada)
              Text(
                widget.book.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.book.authors.isNotEmpty
                    ? widget.book.authors.join(', ')
                    : 'Autor desconocido',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Calificación
              Text(
                'Tu Calificación:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Resumen
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(
                  labelText: 'Resumen (¿De qué trata?)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                minLines: 3,
              ),
              const SizedBox(height: 16),

              // Aprendizajes
              TextFormField(
                controller: _learningsController,
                decoration: const InputDecoration(
                  labelText: '¿Qué aprendí? (Ideas clave, reflexiones)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                minLines: 3,
              ),
              const SizedBox(height: 16),

              // Pensamientos/Opinión
              TextFormField(
                controller: _thoughtsController,
                decoration: const InputDecoration(
                  labelText: 'Mis pensamientos (Opinión personal)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                minLines: 3,
              ),
              const SizedBox(height: 24),

              // Opciones de compartir
              SwitchListTile(
                title: const Text('Compartir con profesores'),
                value: _sharedWithTeachers,
                onChanged: (bool value) {
                  setState(() {
                    _sharedWithTeachers = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Compartir con padres'),
                value: _sharedWithParents,
                onChanged: (bool value) {
                  setState(() {
                    _sharedWithParents = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveFicha,
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Ficha'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (_existingFicha != null) const SizedBox(width: 12),
                  if (_existingFicha != null)
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _deleteFicha,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(Icons.delete, size: 24),
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
}
