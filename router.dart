import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/features/authentication/email_screen.dart';
import 'package:omnisight/features/authentication/login_account_screen.dart';
import 'package:omnisight/features/authentication/password_screen.dart';
import 'package:omnisight/features/authentication/repos/authentication_repos.dart';
import 'package:omnisight/features/authentication/sign_up_screen.dart';
import 'package:omnisight/features/home/car/car_add_screen.dart';
import 'package:omnisight/features/home/car/car_photos_screen.dart';
import 'package:omnisight/features/home/car/car_screen.dart';
import 'package:omnisight/features/home/user/user_add_screen.dart';
import 'package:omnisight/features/home/user/user_screen.dart';
import 'package:omnisight/features/setting/setting_screen.dart';

final routerProvider = Provider((ref) {
  ref.watch(authState);
  return GoRouter(
    initialLocation: CarScreen.routeURL,
    redirect: (context, state) {
      final isLoggedIn = ref.watch(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.matchedLocation != SignUpScreen.routeURL &&
            state.matchedLocation != PasswordScreen.routeURL &&
            state.matchedLocation != LoginAccountScreen.routeURL &&
            state.matchedLocation != EmailScreen.routeURL) {
          return SignUpScreen.routeURL;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: SignUpScreen.routeURL,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: EmailScreen.routeURL,
        builder: (context, state) => EmailScreen(),
      ),
      GoRoute(
        path: LoginAccountScreen.routeURL,
        builder: (context, state) => LoginAccountScreen(),
      ),
      GoRoute(
        path: PasswordScreen.routeURL,
        builder: (context, state) => PasswordScreen(),
      ),
      GoRoute(
        path: CarScreen.routeURL,
        builder: (context, state) => CarScreen(routerState: state),
      ),
      GoRoute(
        path: CarAddScreen.routeURL,
        builder: (context, state) => CarAddScreen(),
      ),
      GoRoute(
        path: '${CarPhotosScreen.routeURL}/:carId',
        builder: (context, state) {
          final carId = state.pathParameters['carId']!;
          return CarPhotosScreen(carId: carId);
        },
      ),
      GoRoute(
        path: UserScreen.routeURL,
        builder: (context, state) => UserScreen(routerState: state),
      ),
      GoRoute(
        path: UserAddScreen.routeURL,
        builder: (context, state) => UserAddScreen(),
      ),
      GoRoute(
        path: SettingScreen.routeURL,
        builder: (context, state) => SettingScreen(),
      ),
    ],
  );
});
