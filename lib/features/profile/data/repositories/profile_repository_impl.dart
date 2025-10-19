import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/profile/domain/repositories/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepositoryImpl(this._firestore);

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('user_profiles').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final profile = UserProfile.fromJson(data);
        return profile;
      }
      return null;
    } catch (e) {
      // Si es un error de permisos, crear un perfil básico en memoria
      if (e.toString().contains('permission denied') ||
          e.toString().contains('PERMISSION_DENIED')) {
        print(
          'Firestore permission denied, creating basic profile for user: $uid',
        );
        // Crear un perfil básico automáticamente
        final basicProfile = UserProfile(
          uid: uid,
          displayName: 'Usuario',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        try {
          await createUserProfile(basicProfile);
          return basicProfile;
        } catch (createError) {
          print(
            'Failed to create profile, returning basic profile: $createError',
          );
          return basicProfile; // Retornar el perfil básico aunque no se guarde
        }
      }
      throw Exception('Error getting user profile: $e');
    }
  }

  @override
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('user_profiles')
          .doc(profile.uid)
          .set(profile.toJson());
    } catch (e) {
      // Si el documento ya existe, intentar actualizarlo
      if (e.toString().contains('already exists')) {
        await updateUserProfile(profile);
      } else if (e.toString().contains('permission denied') ||
          e.toString().contains('PERMISSION_DENIED')) {
        print('Permission denied when creating profile, skipping...');
        // No lanzar excepción, simplemente continuar
        return;
      } else {
        throw Exception('Error creating user profile: $e');
      }
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final data = profile.toJson();

      // Manejar campos null explícitamente para Firestore
      final updateData = <String, dynamic>{};

      data.forEach((key, value) {
        if (value == null) {
          // Para campos null, usar FieldValue.delete() para eliminarlos
          updateData[key] = FieldValue.delete();
        } else {
          updateData[key] = value;
        }
      });

      await _firestore
          .collection('user_profiles')
          .doc(profile.uid)
          .update(updateData);
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  @override
  Future<void> addBookToFavorites(String uid, String bookId) async {
    try {
      await _firestore.collection('user_profiles').doc(uid).update({
        'favoriteBookIds': FieldValue.arrayUnion([bookId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding book to favorites: $e');
    }
  }

  @override
  Future<void> removeBookFromFavorites(String uid, String bookId) async {
    try {
      await _firestore.collection('user_profiles').doc(uid).update({
        'favoriteBookIds': FieldValue.arrayRemove([bookId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error removing book from favorites: $e');
    }
  }

  @override
  Future<void> setCurrentBook(String uid, String bookId, int progress) async {
    try {
      final docRef = _firestore.collection('user_profiles').doc(uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        // Si el documento no existe, crearlo con los campos mínimos
        await docRef.set({
          'uid': uid,
          'displayName': 'Usuario',
          'currentBookId': bookId.isEmpty ? null : bookId,
          'currentBookProgress': bookId.isEmpty ? null : progress,
          'currentBookStartDate':
              bookId.isEmpty ? null : FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return;
      }
      if (bookId.isEmpty) {
        // Limpiar libro actual
        await docRef.update({
          'currentBookId': null,
          'currentBookProgress': null,
          'currentBookStartDate': null,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Establecer nuevo libro actual
        await docRef.update({
          'currentBookId': bookId,
          'currentBookProgress': progress,
          'currentBookStartDate': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Error setting current book: $e');
    }
  }

  @override
  Future<void> updateReadingProgress(String uid, int progress) async {
    try {
      await _firestore.collection('user_profiles').doc(uid).update({
        'currentBookProgress': progress,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating reading progress: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String uid) async {
    try {
      // Eliminar perfil de usuario
      await _firestore.collection('user_profiles').doc(uid).delete();

      // Eliminar todas las fichas de libros del usuario
      final fichasSnapshot =
          await _firestore
              .collection('book_fichas')
              .where('userId', isEqualTo: uid)
              .get();

      // Batch delete para eficiencia
      final batch = _firestore.batch();
      for (final doc in fichasSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Error deleting user profile: $e');
    }
  }
}
