import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/core/config/injection.dart';
import 'package:reading_app/core/theme/app_theme.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/auth/presentation/pages/login_page.dart';
import 'package:reading_app/features/auth/presentation/pages/register_page.dart';
import 'package:reading_app/features/books/presentation/pages/book_search_page.dart';
import 'package:reading_app/features/books/presentation/bloc/book_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/pages/profile_page.dart';
import 'package:reading_app/features/home/presentation/pages/home_page.dart';
import 'package:reading_app/features/profile/presentation/pages/books_tabs_page.dart';
import 'package:reading_app/features/books/presentation/pages/book_ficha_form_page.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure dependencies
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<BookBloc>(create: (context) => getIt<BookBloc>()),
        BlocProvider<ProfileBloc>(create: (context) => getIt<ProfileBloc>()),
      ],
      child: MaterialApp(
        title: 'Reading App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/books': (context) => const BookSearchPage(),
          '/profile': (context) => const ProfilePage(),
          '/books-tabs': (context) => const BooksTabsPage(),
          '/book-ficha-form':
              (context) => BookFichaFormPage(
                book: ModalRoute.of(context)!.settings.arguments as Book,
              ),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.when(
          initial: () => const LoginPage(),
          loading:
              () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
          authenticated: (user) => const HomePage(),
          unauthenticated: () => const LoginPage(),
          error: (message) => const LoginPage(),
        );
      },
    );
  }
}
