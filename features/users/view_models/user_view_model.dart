import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisight/features/users/models/user_profile_model.dart';
import 'package:omnisight/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepo);
    return UserProfileModel.empty();
  }

  Future<void> createProfile({required credential}) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    state = AsyncValue.loading();
    final profile = UserProfileModel(
      uid: credential.user!.uid,
    );

    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
