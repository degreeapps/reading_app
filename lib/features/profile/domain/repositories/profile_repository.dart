import 'package:reading_app/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getUserProfile(String uid);
  Future<void> createUserProfile(UserProfile profile);
  Future<void> updateUserProfile(UserProfile profile);
  Future<void> addBookToFavorites(String uid, String bookId);
  Future<void> removeBookFromFavorites(String uid, String bookId);
  Future<void> setCurrentBook(String uid, String bookId, int progress);
  Future<void> updateReadingProgress(String uid, int progress);
  Future<void> deleteUserProfile(String uid);
}
