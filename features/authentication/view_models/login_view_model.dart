import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisight/features/authentication/repos/authentication_repos.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }

  Future<bool> login(String email, String password) async {
    state = AsyncValue.loading();
    try {
      await _repository.signIn(email, password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

final loginProvider = AsyncNotifierProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);
