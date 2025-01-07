import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/features/authentication/password_screen.dart';
import 'package:omnisight/features/authentication/view_models/sign_up_view_model.dart';
import 'package:omnisight/features/authentication/widgets/sign_up_next_button.dart';
import 'package:flutter/material.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/constants/gaps.dart';

class EmailScreen extends ConsumerStatefulWidget {
  static String routeURL = "/email";
  const EmailScreen({super.key});

  @override
  ConsumerState<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends ConsumerState<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  String _email = "";

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
    }
    super.dispose();
  }

  String? _isEmailValid() {
    if (_email.isEmpty) {
      return null;
    }
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regExp.hasMatch(_email)) {
      return "Invalid email address";
    }
    return null;
  }

  void _onNextTap() {
    if (_email.isEmpty || _isEmailValid() != null) {
      return;
    }
    ref.read(signUpForm.notifier).state = {"email": _email};
    context.push(PasswordScreen.routeURL);
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
          backgroundColor: const Color(0xFF003B46),
          foregroundColor: const Color(0xFFF0F0F0),
          title: const Text(
            "Sign Up",
            style: TextStyle(
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v48,
                  Text(
                    "Email address",
                    style: TextStyle(
                      fontSize: Sizes.size16 + Sizes.size2,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF003B46),
                    ),
                  ),
                  Gaps.v4,
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Enter email address",
                      errorText: _isEmailValid(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF003B46),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF003B46),
                          width: 1.0,
                        ),
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                  Gaps.v28,
                  GestureDetector(
                    onTap: _onNextTap,
                    child: SignUpNextButton(
                        disabled: _email.isEmpty || _isEmailValid() != null),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
