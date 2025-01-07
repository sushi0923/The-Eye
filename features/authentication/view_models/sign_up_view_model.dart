import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisight/features/authentication/repos/authentication_repos.dart';
import 'package:omnisight/features/home/car/car_screen.dart';
import 'package:omnisight/features/users/view_models/users_view_model.dart';
import 'package:go_router/go_router.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(GoRouter router) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);
    state = await AsyncValue.guard(
      () async {
        final userCredential = await _authRepo.signUp(
          form["email"],
          form["password"],
        );
        await users.createProfile(credential: userCredential);
      },
    );

    router.go(CarScreen.routeURL);
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
