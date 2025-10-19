import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/books/domain/entities/book_ficha.dart'; // Import de BookFicha

part 'profile_event.freezed.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.loadProfile(String uid) = _LoadProfile;
  const factory ProfileEvent.updateProfile(UserProfile profile) =
      _UpdateProfile;
  const factory ProfileEvent.addBookToFavorites(String uid, String bookId) =
      _AddBookToFavorites;
  const factory ProfileEvent.removeBookFromFavorites(
    String uid,
    String bookId,
  ) = _RemoveBookFromFavorites;
  const factory ProfileEvent.setCurrentBook(
    String uid,
    String bookId,
    int progress,
  ) = _SetCurrentBook;
  const factory ProfileEvent.updateReadingProgress(String uid, int progress) =
      _UpdateReadingProgress;
  const factory ProfileEvent.markBookAsFinished(String uid, String bookId) =
      _MarkBookAsFinished;
  const factory ProfileEvent.saveBookFicha(BookFicha ficha) =
      _SaveBookFicha; // Nuevo evento
  const factory ProfileEvent.deleteBookFicha(String fichaId, String userId) =
      _DeleteBookFicha; // Nuevo evento
  const factory ProfileEvent.deleteUserProfile(String uid) = _DeleteUserProfile;
}
