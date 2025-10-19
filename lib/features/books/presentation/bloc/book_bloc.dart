import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/domain/usecases/search_books.dart';

part 'book_event.dart';
part 'book_state.dart';
part 'book_bloc.freezed.dart';

@injectable
class BookBloc extends Bloc<BookEvent, BookState> {
  final SearchBooks _searchBooks;

  BookBloc(this._searchBooks) : super(const BookState.initial()) {
    on<BookEvent>((event, emit) async {
      await event.map(
        search: (e) => _onSearch(e, emit),
        clear: (e) => _onClear(e, emit),
      );
    });
  }

  Future<void> _onSearch(_Search event, Emitter<BookState> emit) async {
    emit(const BookState.loading());
    try {
      final books = await _searchBooks(
        query: event.query,
        author: event.author,
        title: event.title,
        isbn: event.isbn,
        category: event.category,
        language: event.language,
      );
      emit(BookState.loaded(books));
    } catch (e) {
      emit(BookState.error(e.toString()));
    }
  }

  Future<void> _onClear(_Clear event, Emitter<BookState> emit) async {
    print('DEBUG: Clearing book search state');
    emit(const BookState.initial());
  }
}
