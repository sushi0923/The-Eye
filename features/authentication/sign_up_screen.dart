import 'package:go_router/go_router.dart';
import 'package:omnisight/features/authentication/email_screen.dart';
import 'package:omnisight/features/authentication/login_account_screen.dart';
import 'package:omnisight/features/authentication/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatelessWidget {
  static String routeURL = "/";
  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) async {
    context.push(LoginAccountScreen.routeURL);
  }

  void _onAccountTap(BuildContext context) {
    context.push(EmailScreen.routeURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003B46),
      body: SafeArea(
        child: Column(
          children: [
            Gaps.v96,
            Gaps.v80,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage("assets/logowhite.png"),
                  width: Sizes.size60,
                ),
                Gaps.h14,
                Text(
                  "The Eye",
                  style: TextStyle(
                    fontSize: Sizes.size36,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF0F0F0),
                  ),
                ),
              ],
            ),
            Gaps.v96,
            GestureDetector(
              onTap: () => _onAccountTap(context),
              child: AuthButton(
                  icon: FaIcon(FontAwesomeIcons.plus),
                  text: "Create an account"),
            ),
            Gaps.v44,
            GestureDetector(
              onTap: () => _onLoginTap(context),
              child: AuthButton(
                  icon: FaIcon(FontAwesomeIcons.user),
                  text: "Log in with OmniSight"),
            ),
          ],
        ),
      ),
    );
  }
}
