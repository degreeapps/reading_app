import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/profile/domain/repositories/profile_repository.dart';

// @Injectable(as: ProfileRepository)
class ProfileRepositoryMemoryImpl implements ProfileRepository {
  final Map<String, UserProfile> _profiles = {};

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    return _profiles[uid];
  }

  @override
  Future<void> createUserProfile(UserProfile profile) async {
    _profiles[profile.uid] = profile;
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    _profiles[profile.uid] = profile;
  }

  @override
  Future<void> addBookToFavorites(String uid, String bookId) async {
    final profile = _profiles[uid];
    if (profile != null) {
      final updatedFavorites = List<String>.from(profile.favoriteBookIds ?? []);
      if (!updatedFavorites.contains(bookId)) {
        updatedFavorites.add(bookId);
        _profiles[uid] = profile.copyWith(
          favoriteBookIds: updatedFavorites,
          updatedAt: DateTime.now(),
        );
      }
    }
  }

  @override
  Future<void> removeBookFromFavorites(String uid, String bookId) async {
    final profile = _profiles[uid];
    if (profile != null) {
      final updatedFavorites = List<String>.from(profile.favoriteBookIds ?? []);
      updatedFavorites.remove(bookId);
      _profiles[uid] = profile.copyWith(
        favoriteBookIds: updatedFavorites,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> setCurrentBook(String uid, String bookId, int progress) async {
    final profile = _profiles[uid];
    if (profile != null) {
      _profiles[uid] = profile.copyWith(
        currentBookId: bookId,
        currentBookProgress: progress,
        currentBookStartDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> updateReadingProgress(String uid, int progress) async {
    final profile = _profiles[uid];
    if (profile != null) {
      _profiles[uid] = profile.copyWith(
        currentBookProgress: progress,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> deleteUserProfile(String uid) async {
    _profiles.remove(uid);
  }
}
