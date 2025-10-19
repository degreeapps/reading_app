part of 'book_bloc.dart';

@freezed
class BookEvent with _$BookEvent {
  const factory BookEvent.search({
    String? query,
    String? author,
    String? title,
    String? isbn,
    String? category,
    String? language,
  }) = _Search;

  const factory BookEvent.clear() = _Clear;
}
