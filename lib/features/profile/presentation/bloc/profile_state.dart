import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded(UserProfile profile) = _Loaded;
  const factory ProfileState.deleted() = _Deleted;
  const factory ProfileState.error(String message) = _Error;
}
