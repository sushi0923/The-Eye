import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/features/authentication/view_models/login_view_model.dart';
import 'package:omnisight/features/authentication/widgets/sign_up_next_button.dart';
import 'package:flutter/material.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/features/home/car/car_screen.dart';

class LoginAccountScreen extends ConsumerStatefulWidget {
  static String routeURL = "/loginaccount";
  const LoginAccountScreen({super.key});

  @override
  ConsumerState<LoginAccountScreen> createState() => _LoginAccountScreenState();
}

class _LoginAccountScreenState extends ConsumerState<LoginAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final isSuccess = await ref
          .read(loginProvider.notifier)
          .login(formData['email']!, formData['password']!);

      if (isSuccess && mounted) {
        context.go(CarScreen.routeURL);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
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
            "Login",
            style: TextStyle(
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size32),
          child: Form(
            key: _formKey,
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
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter email",
                  ),
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['email'] = newValue;
                    }
                  },
                ),
                Gaps.v16,
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: Sizes.size16 + Sizes.size2,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003B46),
                  ),
                ),
                Gaps.v4,
                TextFormField(
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['password'] = newValue;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Enter password",
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
                  onTap: () => {
                    _onSubmitTap(),
                    if (mounted) {context.go(CarScreen.routeURL)},
                  },
                  child: SignUpNextButton(
                    disabled: ref.watch(loginProvider).isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
