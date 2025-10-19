import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';
import 'package:reading_app/features/books/data/datasources/google_books_api.dart';

final getIt = GetIt.instance;

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn.instance;

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  GoogleBooksApi get googleBooksApi => GoogleBooksApi();
}

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize GoogleSignIn with serverClientId before any usage
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '236094728849-9sa8b5pvg67mdp3st7dvpr5fp6a1kbr2.apps.googleusercontent.com', // Web Client ID from google-services.json
  );

  // Initialize injectable
  getIt.init();
}
