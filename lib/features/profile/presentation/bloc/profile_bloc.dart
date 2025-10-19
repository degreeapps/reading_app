import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/profile/domain/usecases/add_book_to_favorites.dart';
import 'package:reading_app/features/profile/domain/usecases/create_user_profile.dart';
import 'package:reading_app/features/profile/domain/usecases/get_user_profile.dart';
import 'package:reading_app/features/profile/domain/usecases/remove_book_from_favorites.dart';
import 'package:reading_app/features/profile/domain/usecases/update_user_profile.dart';
import 'package:reading_app/features/profile/domain/usecases/delete_user_profile.dart';
import 'package:reading_app/features/auth/domain/usecases/delete_account.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:reading_app/features/books/domain/repositories/book_ficha_repository.dart'; // Import del nuevo repositorio

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile _getUserProfile;
  final CreateUserProfile _createUserProfile;
  final UpdateUserProfile _updateUserProfile;
  final AddBookToFavorites _addBookToFavorites;
  final RemoveBookFromFavorites _removeBookFromFavorites;
  final DeleteUserProfile _deleteUserProfile;
  final DeleteAccount _deleteAccount;
  final BookFichaRepository
  _bookFichaRepository; // Inyección del nuevo repositorio

  ProfileBloc(
    this._getUserProfile,
    this._createUserProfile,
    this._updateUserProfile,
    this._addBookToFavorites,
    this._removeBookFromFavorites,
    this._deleteUserProfile,
    this._deleteAccount,
    this._bookFichaRepository,
  ) : super(const ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      await event.map(
        loadProfile: (e) async {
          emit(const ProfileState.loading());
          try {
            final profile = await _getUserProfile(e.uid);
            if (profile != null) {
              emit(ProfileState.loaded(profile));
            } else {
              // Si no existe el perfil, crear uno básico
              final basicProfile = UserProfile(
                uid: e.uid,
                displayName: 'Usuario',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              await _createUserProfile(basicProfile);
              emit(ProfileState.loaded(basicProfile));
            }
          } catch (e) {
            emit(ProfileState.error(e.toString()));
          }
        },
        updateProfile: (e) async {
          emit(const ProfileState.loading());
          try {
            await _updateUserProfile(e.profile);
            emit(ProfileState.loaded(e.profile));
          } catch (e) {
            emit(ProfileState.error(e.toString()));
          }
        },
        addBookToFavorites: (e) async {
          try {
            await _addBookToFavorites(e.uid, e.bookId);
            // Reload profile to get updated favorites
            final profile = await _getUserProfile(e.uid);
            if (profile != null) {
              emit(ProfileState.loaded(profile));
            }
          } catch (e) {
            emit(ProfileState.error(e.toString()));
          }
        },
        removeBookFromFavorites: (e) async {
          try {
            await _removeBookFromFavorites(e.uid, e.bookId);
            // Reload profile to get updated favorites
            final profile = await _getUserProfile(e.uid);
            if (profile != null) {
              emit(ProfileState.loaded(profile));
            }
          } catch (e) {
            emit(ProfileState.error(e.toString()));
          }
        },
        setCurrentBook: (e) async {
          try {
            // Get current profile
            final currentProfile = await _getUserProfile(e.uid);
            if (currentProfile != null) {
              // If bookId is empty, clear current book
              if (e.bookId.isEmpty) {
                print('DEBUG: Clearing current book for user ${e.uid}');
                final updatedProfile = currentProfile.copyWithClearCurrentBook(
                  updatedAt: DateTime.now(),
                );
                await _updateUserProfile(updatedProfile);
                print(
                  'DEBUG: Emitting updated profile with null currentBookId',
                );
                emit(ProfileState.loaded(updatedProfile));
              } else {
                print(
                  'DEBUG: Setting current book ${e.bookId} for user ${e.uid}',
                );
                // Update profile with new current book
                final updatedProfile = currentProfile.copyWith(
                  currentBookId: e.bookId,
                  currentBookProgress: e.progress,
                  currentBookStartDate: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                await _updateUserProfile(updatedProfile);
                emit(ProfileState.loaded(updatedProfile));
              }
            }
          } catch (e) {
            print('DEBUG: Error in setCurrentBook: $e');
            emit(ProfileState.error(e.toString()));
          }
        },
        updateReadingProgress: (e) async {
          try {
            // Get current profile
            final currentProfile = await _getUserProfile(e.uid);
            if (currentProfile != null) {
              // Update only the reading progress
              final updatedProfile = currentProfile.copyWith(
                currentBookProgress: e.progress,
                updatedAt: DateTime.now(),
              );
              await _updateUserProfile(updatedProfile);
              emit(ProfileState.loaded(updatedProfile));
            }
          } catch (e) {
            emit(ProfileState.error(e.toString()));
          }
        },
        markBookAsFinished: (e) async {
          try {
            // Get current profile
            final currentProfile = await _getUserProfile(e.uid);
            if (currentProfile != null) {
              // Obtener la lista actual de libros leídos
              final completedBooks = List<String>.from(
                currentProfile.completedBookIds ?? [],
              );
              if (!completedBooks.contains(e.bookId)) {
                completedBooks.add(e.bookId);
              }
              // Mark book as finished y limpiar libro actual
              final updatedProfile = currentProfile.copyWithClearCurrentBook(
                totalBooksRead: (currentProfile.totalBooksRead ?? 0) + 1,
                completedBookIds: completedBooks,
                updatedAt: DateTime.now(),
              );
              await _updateUserProfile(updatedProfile);
              emit(ProfileState.loaded(updatedProfile));
            }
          } catch (e) {
            emit(ProfileState.error(e.toString()));
          }
        },
        saveBookFicha: (e) async {
          try {
            await _bookFichaRepository.saveBookFicha(e.ficha);
            // Reload profile to get updated ficha
            final profile = await _getUserProfile(
              e.ficha.userId,
            ); // Corregido: e.uid -> e.ficha.userId
            if (profile != null) {
              emit(ProfileState.loaded(profile));
            }
          } catch (e) {
            emit(ProfileState.error(e.toString()));
          }
        },
        deleteBookFicha: (e) async {
          try {
            await _bookFichaRepository.deleteBookFicha(e.fichaId);
            // Reload profile to reflect the deleted ficha
            final profile = await _getUserProfile(e.userId);
            if (profile != null) {
              emit(ProfileState.loaded(profile));
            }
          } catch (e) {
            emit(ProfileState.error(e.toString()));
          }
        },
        deleteUserProfile: (e) async {
          emit(const ProfileState.loading());
          try {
            // 1. Eliminar todos los datos de Firestore (perfil + fichas)
            await _deleteUserProfile(e.uid);

            // 2. Eliminar el usuario de Firebase Auth
            await _deleteAccount();

            // 3. Emitir estado deleted para indicar eliminación exitosa
            emit(const ProfileState.deleted());
          } catch (err) {
            emit(ProfileState.error(err.toString()));
          }
        },
      );
    });
  }
}
