// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:reading_app/core/config/injection.dart' as _i1055;
import 'package:reading_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i105;
import 'package:reading_app/features/auth/domain/repositories/auth_repository.dart'
    as _i414;
import 'package:reading_app/features/auth/domain/usecases/change_password.dart'
    as _i168;
import 'package:reading_app/features/auth/domain/usecases/delete_account.dart'
    as _i565;
import 'package:reading_app/features/auth/domain/usecases/sign_in_with_email.dart'
    as _i480;
import 'package:reading_app/features/auth/domain/usecases/sign_in_with_google.dart'
    as _i316;
import 'package:reading_app/features/auth/domain/usecases/sign_out.dart'
    as _i478;
import 'package:reading_app/features/auth/domain/usecases/sign_up_with_email.dart'
    as _i256;
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i371;
import 'package:reading_app/features/books/data/datasources/google_books_api.dart'
    as _i42;
import 'package:reading_app/features/books/data/repositories/book_ficha_repository_impl.dart'
    as _i336;
import 'package:reading_app/features/books/data/repositories/book_repository_impl.dart'
    as _i848;
import 'package:reading_app/features/books/domain/repositories/book_ficha_repository.dart'
    as _i668;
import 'package:reading_app/features/books/domain/repositories/book_repository.dart'
    as _i557;
import 'package:reading_app/features/books/domain/usecases/add_book.dart'
    as _i690;
import 'package:reading_app/features/books/domain/usecases/add_book_to_favorites.dart'
    as _i230;
import 'package:reading_app/features/books/domain/usecases/get_favorite_books.dart'
    as _i265;
import 'package:reading_app/features/books/domain/usecases/remove_book_from_favorites.dart'
    as _i596;
import 'package:reading_app/features/books/domain/usecases/search_books.dart'
    as _i730;
import 'package:reading_app/features/books/presentation/bloc/book_bloc.dart'
    as _i177;
import 'package:reading_app/features/profile/data/repositories/friends_repository_impl.dart'
    as _i506;
import 'package:reading_app/features/profile/data/repositories/profile_repository_impl.dart'
    as _i157;
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart'
    as _i647;
import 'package:reading_app/features/profile/domain/repositories/profile_repository.dart'
    as _i83;
import 'package:reading_app/features/profile/domain/usecases/accept_friend_request.dart'
    as _i0;
import 'package:reading_app/features/profile/domain/usecases/add_book_to_favorites.dart'
    as _i218;
import 'package:reading_app/features/profile/domain/usecases/check_friendship_status.dart'
    as _i720;
import 'package:reading_app/features/profile/domain/usecases/create_user_profile.dart'
    as _i369;
import 'package:reading_app/features/profile/domain/usecases/delete_user_profile.dart'
    as _i858;
import 'package:reading_app/features/profile/domain/usecases/get_friend_requests.dart'
    as _i198;
import 'package:reading_app/features/profile/domain/usecases/get_friends.dart'
    as _i460;
import 'package:reading_app/features/profile/domain/usecases/get_user_profile.dart'
    as _i827;
import 'package:reading_app/features/profile/domain/usecases/reject_friend_request.dart'
    as _i192;
import 'package:reading_app/features/profile/domain/usecases/remove_book_from_favorites.dart'
    as _i81;
import 'package:reading_app/features/profile/domain/usecases/remove_friend.dart'
    as _i905;
import 'package:reading_app/features/profile/domain/usecases/send_friend_request.dart'
    as _i647;
import 'package:reading_app/features/profile/domain/usecases/update_user_profile.dart'
    as _i234;
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart'
    as _i649;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i42.GoogleBooksApi>(() => firebaseModule.googleBooksApi);
    gh.factory<_i557.BookRepository>(
      () => _i848.BookRepositoryImpl(
        gh<_i42.GoogleBooksApi>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i668.BookFichaRepository>(
      () => _i336.BookFichaRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i647.FriendsRepository>(
      () => _i506.FriendsRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i647.SendFriendRequest>(
      () => _i647.SendFriendRequest(gh<_i647.FriendsRepository>()),
    );
    gh.factory<_i198.GetFriendRequests>(
      () => _i198.GetFriendRequests(gh<_i647.FriendsRepository>()),
    );
    gh.factory<_i0.AcceptFriendRequest>(
      () => _i0.AcceptFriendRequest(gh<_i647.FriendsRepository>()),
    );
    gh.factory<_i192.RejectFriendRequest>(
      () => _i192.RejectFriendRequest(gh<_i647.FriendsRepository>()),
    );
    gh.factory<_i460.GetFriends>(
      () => _i460.GetFriends(gh<_i647.FriendsRepository>()),
    );
    gh.factory<_i720.CheckFriendshipStatus>(
      () => _i720.CheckFriendshipStatus(gh<_i647.FriendsRepository>()),
    );
    gh.factory<_i905.RemoveFriend>(
      () => _i905.RemoveFriend(gh<_i647.FriendsRepository>()),
    );
    gh.factory<_i83.ProfileRepository>(
      () => _i157.ProfileRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i414.AuthRepository>(
      () => _i105.AuthRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.factory<_i827.GetUserProfile>(
      () => _i827.GetUserProfile(gh<_i83.ProfileRepository>()),
    );
    gh.factory<_i234.UpdateUserProfile>(
      () => _i234.UpdateUserProfile(gh<_i83.ProfileRepository>()),
    );
    gh.factory<_i218.AddBookToFavorites>(
      () => _i218.AddBookToFavorites(gh<_i83.ProfileRepository>()),
    );
    gh.factory<_i81.RemoveBookFromFavorites>(
      () => _i81.RemoveBookFromFavorites(gh<_i83.ProfileRepository>()),
    );
    gh.factory<_i369.CreateUserProfile>(
      () => _i369.CreateUserProfile(gh<_i83.ProfileRepository>()),
    );
    gh.factory<_i858.DeleteUserProfile>(
      () => _i858.DeleteUserProfile(gh<_i83.ProfileRepository>()),
    );
    gh.factory<_i480.SignInWithEmail>(
      () => _i480.SignInWithEmail(gh<_i414.AuthRepository>()),
    );
    gh.factory<_i256.SignUpWithEmail>(
      () => _i256.SignUpWithEmail(gh<_i414.AuthRepository>()),
    );
    gh.factory<_i316.SignInWithGoogle>(
      () => _i316.SignInWithGoogle(gh<_i414.AuthRepository>()),
    );
    gh.factory<_i478.SignOut>(() => _i478.SignOut(gh<_i414.AuthRepository>()));
    gh.factory<_i168.ChangePassword>(
      () => _i168.ChangePassword(gh<_i414.AuthRepository>()),
    );
    gh.factory<_i730.SearchBooks>(
      () => _i730.SearchBooks(gh<_i557.BookRepository>()),
    );
    gh.factory<_i690.AddBook>(() => _i690.AddBook(gh<_i557.BookRepository>()));
    gh.factory<_i265.GetFavoriteBooks>(
      () => _i265.GetFavoriteBooks(gh<_i557.BookRepository>()),
    );
    gh.factory<_i230.AddBookToFavorites>(
      () => _i230.AddBookToFavorites(gh<_i557.BookRepository>()),
    );
    gh.factory<_i596.RemoveBookFromFavorites>(
      () => _i596.RemoveBookFromFavorites(gh<_i557.BookRepository>()),
    );
    gh.factory<_i565.DeleteAccount>(
      () => _i565.DeleteAccount(gh<_i414.AuthRepository>()),
    );
    gh.factory<_i649.ProfileBloc>(
      () => _i649.ProfileBloc(
        gh<_i827.GetUserProfile>(),
        gh<_i369.CreateUserProfile>(),
        gh<_i234.UpdateUserProfile>(),
        gh<_i218.AddBookToFavorites>(),
        gh<_i81.RemoveBookFromFavorites>(),
        gh<_i858.DeleteUserProfile>(),
        gh<_i565.DeleteAccount>(),
        gh<_i668.BookFichaRepository>(),
      ),
    );
    gh.factory<_i371.AuthBloc>(
      () => _i371.AuthBloc(
        gh<_i480.SignInWithEmail>(),
        gh<_i256.SignUpWithEmail>(),
        gh<_i316.SignInWithGoogle>(),
        gh<_i478.SignOut>(),
        gh<_i168.ChangePassword>(),
      ),
    );
    gh.factory<_i177.BookBloc>(() => _i177.BookBloc(gh<_i730.SearchBooks>()));
    return this;
  }
}

class _$FirebaseModule extends _i1055.FirebaseModule {}
