// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileEvent()';
}


}

/// @nodoc
class $ProfileEventCopyWith<$Res>  {
$ProfileEventCopyWith(ProfileEvent _, $Res Function(ProfileEvent) __);
}


/// Adds pattern-matching-related methods to [ProfileEvent].
extension ProfileEventPatterns on ProfileEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadProfile value)?  loadProfile,TResult Function( _UpdateProfile value)?  updateProfile,TResult Function( _AddBookToFavorites value)?  addBookToFavorites,TResult Function( _RemoveBookFromFavorites value)?  removeBookFromFavorites,TResult Function( _SetCurrentBook value)?  setCurrentBook,TResult Function( _UpdateReadingProgress value)?  updateReadingProgress,TResult Function( _MarkBookAsFinished value)?  markBookAsFinished,TResult Function( _SaveBookFicha value)?  saveBookFicha,TResult Function( _DeleteBookFicha value)?  deleteBookFicha,TResult Function( _DeleteUserProfile value)?  deleteUserProfile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadProfile() when loadProfile != null:
return loadProfile(_that);case _UpdateProfile() when updateProfile != null:
return updateProfile(_that);case _AddBookToFavorites() when addBookToFavorites != null:
return addBookToFavorites(_that);case _RemoveBookFromFavorites() when removeBookFromFavorites != null:
return removeBookFromFavorites(_that);case _SetCurrentBook() when setCurrentBook != null:
return setCurrentBook(_that);case _UpdateReadingProgress() when updateReadingProgress != null:
return updateReadingProgress(_that);case _MarkBookAsFinished() when markBookAsFinished != null:
return markBookAsFinished(_that);case _SaveBookFicha() when saveBookFicha != null:
return saveBookFicha(_that);case _DeleteBookFicha() when deleteBookFicha != null:
return deleteBookFicha(_that);case _DeleteUserProfile() when deleteUserProfile != null:
return deleteUserProfile(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadProfile value)  loadProfile,required TResult Function( _UpdateProfile value)  updateProfile,required TResult Function( _AddBookToFavorites value)  addBookToFavorites,required TResult Function( _RemoveBookFromFavorites value)  removeBookFromFavorites,required TResult Function( _SetCurrentBook value)  setCurrentBook,required TResult Function( _UpdateReadingProgress value)  updateReadingProgress,required TResult Function( _MarkBookAsFinished value)  markBookAsFinished,required TResult Function( _SaveBookFicha value)  saveBookFicha,required TResult Function( _DeleteBookFicha value)  deleteBookFicha,required TResult Function( _DeleteUserProfile value)  deleteUserProfile,}){
final _that = this;
switch (_that) {
case _LoadProfile():
return loadProfile(_that);case _UpdateProfile():
return updateProfile(_that);case _AddBookToFavorites():
return addBookToFavorites(_that);case _RemoveBookFromFavorites():
return removeBookFromFavorites(_that);case _SetCurrentBook():
return setCurrentBook(_that);case _UpdateReadingProgress():
return updateReadingProgress(_that);case _MarkBookAsFinished():
return markBookAsFinished(_that);case _SaveBookFicha():
return saveBookFicha(_that);case _DeleteBookFicha():
return deleteBookFicha(_that);case _DeleteUserProfile():
return deleteUserProfile(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadProfile value)?  loadProfile,TResult? Function( _UpdateProfile value)?  updateProfile,TResult? Function( _AddBookToFavorites value)?  addBookToFavorites,TResult? Function( _RemoveBookFromFavorites value)?  removeBookFromFavorites,TResult? Function( _SetCurrentBook value)?  setCurrentBook,TResult? Function( _UpdateReadingProgress value)?  updateReadingProgress,TResult? Function( _MarkBookAsFinished value)?  markBookAsFinished,TResult? Function( _SaveBookFicha value)?  saveBookFicha,TResult? Function( _DeleteBookFicha value)?  deleteBookFicha,TResult? Function( _DeleteUserProfile value)?  deleteUserProfile,}){
final _that = this;
switch (_that) {
case _LoadProfile() when loadProfile != null:
return loadProfile(_that);case _UpdateProfile() when updateProfile != null:
return updateProfile(_that);case _AddBookToFavorites() when addBookToFavorites != null:
return addBookToFavorites(_that);case _RemoveBookFromFavorites() when removeBookFromFavorites != null:
return removeBookFromFavorites(_that);case _SetCurrentBook() when setCurrentBook != null:
return setCurrentBook(_that);case _UpdateReadingProgress() when updateReadingProgress != null:
return updateReadingProgress(_that);case _MarkBookAsFinished() when markBookAsFinished != null:
return markBookAsFinished(_that);case _SaveBookFicha() when saveBookFicha != null:
return saveBookFicha(_that);case _DeleteBookFicha() when deleteBookFicha != null:
return deleteBookFicha(_that);case _DeleteUserProfile() when deleteUserProfile != null:
return deleteUserProfile(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String uid)?  loadProfile,TResult Function( UserProfile profile)?  updateProfile,TResult Function( String uid,  String bookId)?  addBookToFavorites,TResult Function( String uid,  String bookId)?  removeBookFromFavorites,TResult Function( String uid,  String bookId,  int progress)?  setCurrentBook,TResult Function( String uid,  int progress)?  updateReadingProgress,TResult Function( String uid,  String bookId)?  markBookAsFinished,TResult Function( BookFicha ficha)?  saveBookFicha,TResult Function( String fichaId,  String userId)?  deleteBookFicha,TResult Function( String uid)?  deleteUserProfile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadProfile() when loadProfile != null:
return loadProfile(_that.uid);case _UpdateProfile() when updateProfile != null:
return updateProfile(_that.profile);case _AddBookToFavorites() when addBookToFavorites != null:
return addBookToFavorites(_that.uid,_that.bookId);case _RemoveBookFromFavorites() when removeBookFromFavorites != null:
return removeBookFromFavorites(_that.uid,_that.bookId);case _SetCurrentBook() when setCurrentBook != null:
return setCurrentBook(_that.uid,_that.bookId,_that.progress);case _UpdateReadingProgress() when updateReadingProgress != null:
return updateReadingProgress(_that.uid,_that.progress);case _MarkBookAsFinished() when markBookAsFinished != null:
return markBookAsFinished(_that.uid,_that.bookId);case _SaveBookFicha() when saveBookFicha != null:
return saveBookFicha(_that.ficha);case _DeleteBookFicha() when deleteBookFicha != null:
return deleteBookFicha(_that.fichaId,_that.userId);case _DeleteUserProfile() when deleteUserProfile != null:
return deleteUserProfile(_that.uid);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String uid)  loadProfile,required TResult Function( UserProfile profile)  updateProfile,required TResult Function( String uid,  String bookId)  addBookToFavorites,required TResult Function( String uid,  String bookId)  removeBookFromFavorites,required TResult Function( String uid,  String bookId,  int progress)  setCurrentBook,required TResult Function( String uid,  int progress)  updateReadingProgress,required TResult Function( String uid,  String bookId)  markBookAsFinished,required TResult Function( BookFicha ficha)  saveBookFicha,required TResult Function( String fichaId,  String userId)  deleteBookFicha,required TResult Function( String uid)  deleteUserProfile,}) {final _that = this;
switch (_that) {
case _LoadProfile():
return loadProfile(_that.uid);case _UpdateProfile():
return updateProfile(_that.profile);case _AddBookToFavorites():
return addBookToFavorites(_that.uid,_that.bookId);case _RemoveBookFromFavorites():
return removeBookFromFavorites(_that.uid,_that.bookId);case _SetCurrentBook():
return setCurrentBook(_that.uid,_that.bookId,_that.progress);case _UpdateReadingProgress():
return updateReadingProgress(_that.uid,_that.progress);case _MarkBookAsFinished():
return markBookAsFinished(_that.uid,_that.bookId);case _SaveBookFicha():
return saveBookFicha(_that.ficha);case _DeleteBookFicha():
return deleteBookFicha(_that.fichaId,_that.userId);case _DeleteUserProfile():
return deleteUserProfile(_that.uid);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String uid)?  loadProfile,TResult? Function( UserProfile profile)?  updateProfile,TResult? Function( String uid,  String bookId)?  addBookToFavorites,TResult? Function( String uid,  String bookId)?  removeBookFromFavorites,TResult? Function( String uid,  String bookId,  int progress)?  setCurrentBook,TResult? Function( String uid,  int progress)?  updateReadingProgress,TResult? Function( String uid,  String bookId)?  markBookAsFinished,TResult? Function( BookFicha ficha)?  saveBookFicha,TResult? Function( String fichaId,  String userId)?  deleteBookFicha,TResult? Function( String uid)?  deleteUserProfile,}) {final _that = this;
switch (_that) {
case _LoadProfile() when loadProfile != null:
return loadProfile(_that.uid);case _UpdateProfile() when updateProfile != null:
return updateProfile(_that.profile);case _AddBookToFavorites() when addBookToFavorites != null:
return addBookToFavorites(_that.uid,_that.bookId);case _RemoveBookFromFavorites() when removeBookFromFavorites != null:
return removeBookFromFavorites(_that.uid,_that.bookId);case _SetCurrentBook() when setCurrentBook != null:
return setCurrentBook(_that.uid,_that.bookId,_that.progress);case _UpdateReadingProgress() when updateReadingProgress != null:
return updateReadingProgress(_that.uid,_that.progress);case _MarkBookAsFinished() when markBookAsFinished != null:
return markBookAsFinished(_that.uid,_that.bookId);case _SaveBookFicha() when saveBookFicha != null:
return saveBookFicha(_that.ficha);case _DeleteBookFicha() when deleteBookFicha != null:
return deleteBookFicha(_that.fichaId,_that.userId);case _DeleteUserProfile() when deleteUserProfile != null:
return deleteUserProfile(_that.uid);case _:
  return null;

}
}

}

/// @nodoc


class _LoadProfile implements ProfileEvent {
  const _LoadProfile(this.uid);
  

 final  String uid;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadProfileCopyWith<_LoadProfile> get copyWith => __$LoadProfileCopyWithImpl<_LoadProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadProfile&&(identical(other.uid, uid) || other.uid == uid));
}


@override
int get hashCode => Object.hash(runtimeType,uid);

@override
String toString() {
  return 'ProfileEvent.loadProfile(uid: $uid)';
}


}

/// @nodoc
abstract mixin class _$LoadProfileCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$LoadProfileCopyWith(_LoadProfile value, $Res Function(_LoadProfile) _then) = __$LoadProfileCopyWithImpl;
@useResult
$Res call({
 String uid
});




}
/// @nodoc
class __$LoadProfileCopyWithImpl<$Res>
    implements _$LoadProfileCopyWith<$Res> {
  __$LoadProfileCopyWithImpl(this._self, this._then);

  final _LoadProfile _self;
  final $Res Function(_LoadProfile) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,}) {
  return _then(_LoadProfile(
null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateProfile implements ProfileEvent {
  const _UpdateProfile(this.profile);
  

 final  UserProfile profile;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProfileCopyWith<_UpdateProfile> get copyWith => __$UpdateProfileCopyWithImpl<_UpdateProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProfile&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'ProfileEvent.updateProfile(profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$UpdateProfileCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$UpdateProfileCopyWith(_UpdateProfile value, $Res Function(_UpdateProfile) _then) = __$UpdateProfileCopyWithImpl;
@useResult
$Res call({
 UserProfile profile
});




}
/// @nodoc
class __$UpdateProfileCopyWithImpl<$Res>
    implements _$UpdateProfileCopyWith<$Res> {
  __$UpdateProfileCopyWithImpl(this._self, this._then);

  final _UpdateProfile _self;
  final $Res Function(_UpdateProfile) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(_UpdateProfile(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile,
  ));
}


}

/// @nodoc


class _AddBookToFavorites implements ProfileEvent {
  const _AddBookToFavorites(this.uid, this.bookId);
  

 final  String uid;
 final  String bookId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddBookToFavoritesCopyWith<_AddBookToFavorites> get copyWith => __$AddBookToFavoritesCopyWithImpl<_AddBookToFavorites>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddBookToFavorites&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.bookId, bookId) || other.bookId == bookId));
}


@override
int get hashCode => Object.hash(runtimeType,uid,bookId);

@override
String toString() {
  return 'ProfileEvent.addBookToFavorites(uid: $uid, bookId: $bookId)';
}


}

/// @nodoc
abstract mixin class _$AddBookToFavoritesCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$AddBookToFavoritesCopyWith(_AddBookToFavorites value, $Res Function(_AddBookToFavorites) _then) = __$AddBookToFavoritesCopyWithImpl;
@useResult
$Res call({
 String uid, String bookId
});




}
/// @nodoc
class __$AddBookToFavoritesCopyWithImpl<$Res>
    implements _$AddBookToFavoritesCopyWith<$Res> {
  __$AddBookToFavoritesCopyWithImpl(this._self, this._then);

  final _AddBookToFavorites _self;
  final $Res Function(_AddBookToFavorites) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? bookId = null,}) {
  return _then(_AddBookToFavorites(
null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RemoveBookFromFavorites implements ProfileEvent {
  const _RemoveBookFromFavorites(this.uid, this.bookId);
  

 final  String uid;
 final  String bookId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveBookFromFavoritesCopyWith<_RemoveBookFromFavorites> get copyWith => __$RemoveBookFromFavoritesCopyWithImpl<_RemoveBookFromFavorites>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveBookFromFavorites&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.bookId, bookId) || other.bookId == bookId));
}


@override
int get hashCode => Object.hash(runtimeType,uid,bookId);

@override
String toString() {
  return 'ProfileEvent.removeBookFromFavorites(uid: $uid, bookId: $bookId)';
}


}

/// @nodoc
abstract mixin class _$RemoveBookFromFavoritesCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$RemoveBookFromFavoritesCopyWith(_RemoveBookFromFavorites value, $Res Function(_RemoveBookFromFavorites) _then) = __$RemoveBookFromFavoritesCopyWithImpl;
@useResult
$Res call({
 String uid, String bookId
});




}
/// @nodoc
class __$RemoveBookFromFavoritesCopyWithImpl<$Res>
    implements _$RemoveBookFromFavoritesCopyWith<$Res> {
  __$RemoveBookFromFavoritesCopyWithImpl(this._self, this._then);

  final _RemoveBookFromFavorites _self;
  final $Res Function(_RemoveBookFromFavorites) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? bookId = null,}) {
  return _then(_RemoveBookFromFavorites(
null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SetCurrentBook implements ProfileEvent {
  const _SetCurrentBook(this.uid, this.bookId, this.progress);
  

 final  String uid;
 final  String bookId;
 final  int progress;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetCurrentBookCopyWith<_SetCurrentBook> get copyWith => __$SetCurrentBookCopyWithImpl<_SetCurrentBook>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetCurrentBook&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,uid,bookId,progress);

@override
String toString() {
  return 'ProfileEvent.setCurrentBook(uid: $uid, bookId: $bookId, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$SetCurrentBookCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$SetCurrentBookCopyWith(_SetCurrentBook value, $Res Function(_SetCurrentBook) _then) = __$SetCurrentBookCopyWithImpl;
@useResult
$Res call({
 String uid, String bookId, int progress
});




}
/// @nodoc
class __$SetCurrentBookCopyWithImpl<$Res>
    implements _$SetCurrentBookCopyWith<$Res> {
  __$SetCurrentBookCopyWithImpl(this._self, this._then);

  final _SetCurrentBook _self;
  final $Res Function(_SetCurrentBook) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? bookId = null,Object? progress = null,}) {
  return _then(_SetCurrentBook(
null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _UpdateReadingProgress implements ProfileEvent {
  const _UpdateReadingProgress(this.uid, this.progress);
  

 final  String uid;
 final  int progress;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateReadingProgressCopyWith<_UpdateReadingProgress> get copyWith => __$UpdateReadingProgressCopyWithImpl<_UpdateReadingProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateReadingProgress&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,uid,progress);

@override
String toString() {
  return 'ProfileEvent.updateReadingProgress(uid: $uid, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$UpdateReadingProgressCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$UpdateReadingProgressCopyWith(_UpdateReadingProgress value, $Res Function(_UpdateReadingProgress) _then) = __$UpdateReadingProgressCopyWithImpl;
@useResult
$Res call({
 String uid, int progress
});




}
/// @nodoc
class __$UpdateReadingProgressCopyWithImpl<$Res>
    implements _$UpdateReadingProgressCopyWith<$Res> {
  __$UpdateReadingProgressCopyWithImpl(this._self, this._then);

  final _UpdateReadingProgress _self;
  final $Res Function(_UpdateReadingProgress) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? progress = null,}) {
  return _then(_UpdateReadingProgress(
null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _MarkBookAsFinished implements ProfileEvent {
  const _MarkBookAsFinished(this.uid, this.bookId);
  

 final  String uid;
 final  String bookId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarkBookAsFinishedCopyWith<_MarkBookAsFinished> get copyWith => __$MarkBookAsFinishedCopyWithImpl<_MarkBookAsFinished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarkBookAsFinished&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.bookId, bookId) || other.bookId == bookId));
}


@override
int get hashCode => Object.hash(runtimeType,uid,bookId);

@override
String toString() {
  return 'ProfileEvent.markBookAsFinished(uid: $uid, bookId: $bookId)';
}


}

/// @nodoc
abstract mixin class _$MarkBookAsFinishedCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$MarkBookAsFinishedCopyWith(_MarkBookAsFinished value, $Res Function(_MarkBookAsFinished) _then) = __$MarkBookAsFinishedCopyWithImpl;
@useResult
$Res call({
 String uid, String bookId
});




}
/// @nodoc
class __$MarkBookAsFinishedCopyWithImpl<$Res>
    implements _$MarkBookAsFinishedCopyWith<$Res> {
  __$MarkBookAsFinishedCopyWithImpl(this._self, this._then);

  final _MarkBookAsFinished _self;
  final $Res Function(_MarkBookAsFinished) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? bookId = null,}) {
  return _then(_MarkBookAsFinished(
null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveBookFicha implements ProfileEvent {
  const _SaveBookFicha(this.ficha);
  

 final  BookFicha ficha;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveBookFichaCopyWith<_SaveBookFicha> get copyWith => __$SaveBookFichaCopyWithImpl<_SaveBookFicha>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveBookFicha&&(identical(other.ficha, ficha) || other.ficha == ficha));
}


@override
int get hashCode => Object.hash(runtimeType,ficha);

@override
String toString() {
  return 'ProfileEvent.saveBookFicha(ficha: $ficha)';
}


}

/// @nodoc
abstract mixin class _$SaveBookFichaCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$SaveBookFichaCopyWith(_SaveBookFicha value, $Res Function(_SaveBookFicha) _then) = __$SaveBookFichaCopyWithImpl;
@useResult
$Res call({
 BookFicha ficha
});




}
/// @nodoc
class __$SaveBookFichaCopyWithImpl<$Res>
    implements _$SaveBookFichaCopyWith<$Res> {
  __$SaveBookFichaCopyWithImpl(this._self, this._then);

  final _SaveBookFicha _self;
  final $Res Function(_SaveBookFicha) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ficha = null,}) {
  return _then(_SaveBookFicha(
null == ficha ? _self.ficha : ficha // ignore: cast_nullable_to_non_nullable
as BookFicha,
  ));
}


}

/// @nodoc


class _DeleteBookFicha implements ProfileEvent {
  const _DeleteBookFicha(this.fichaId, this.userId);
  

 final  String fichaId;
 final  String userId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteBookFichaCopyWith<_DeleteBookFicha> get copyWith => __$DeleteBookFichaCopyWithImpl<_DeleteBookFicha>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteBookFicha&&(identical(other.fichaId, fichaId) || other.fichaId == fichaId)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,fichaId,userId);

@override
String toString() {
  return 'ProfileEvent.deleteBookFicha(fichaId: $fichaId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$DeleteBookFichaCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$DeleteBookFichaCopyWith(_DeleteBookFicha value, $Res Function(_DeleteBookFicha) _then) = __$DeleteBookFichaCopyWithImpl;
@useResult
$Res call({
 String fichaId, String userId
});




}
/// @nodoc
class __$DeleteBookFichaCopyWithImpl<$Res>
    implements _$DeleteBookFichaCopyWith<$Res> {
  __$DeleteBookFichaCopyWithImpl(this._self, this._then);

  final _DeleteBookFicha _self;
  final $Res Function(_DeleteBookFicha) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fichaId = null,Object? userId = null,}) {
  return _then(_DeleteBookFicha(
null == fichaId ? _self.fichaId : fichaId // ignore: cast_nullable_to_non_nullable
as String,null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteUserProfile implements ProfileEvent {
  const _DeleteUserProfile(this.uid);
  

 final  String uid;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteUserProfileCopyWith<_DeleteUserProfile> get copyWith => __$DeleteUserProfileCopyWithImpl<_DeleteUserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteUserProfile&&(identical(other.uid, uid) || other.uid == uid));
}


@override
int get hashCode => Object.hash(runtimeType,uid);

@override
String toString() {
  return 'ProfileEvent.deleteUserProfile(uid: $uid)';
}


}

/// @nodoc
abstract mixin class _$DeleteUserProfileCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory _$DeleteUserProfileCopyWith(_DeleteUserProfile value, $Res Function(_DeleteUserProfile) _then) = __$DeleteUserProfileCopyWithImpl;
@useResult
$Res call({
 String uid
});




}
/// @nodoc
class __$DeleteUserProfileCopyWithImpl<$Res>
    implements _$DeleteUserProfileCopyWith<$Res> {
  __$DeleteUserProfileCopyWithImpl(this._self, this._then);

  final _DeleteUserProfile _self;
  final $Res Function(_DeleteUserProfile) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,}) {
  return _then(_DeleteUserProfile(
null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
