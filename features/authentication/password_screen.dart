import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/features/authentication/view_models/sign_up_view_model.dart';
import 'package:omnisight/features/authentication/widgets/sign_up_next_button.dart';
import 'package:flutter/material.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  static String routeURL = "/password";
  const PasswordScreen({super.key});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  String _password = "";
  String _confirmpassword = "";
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });

    _confirmpasswordController.addListener(() {
      setState(() {
        _confirmpassword = _confirmpasswordController.text;
      });
    });
  }

  @override
  void dispose() {
    if (mounted) {
      _passwordController.dispose();
      _confirmpasswordController.dispose();
    }
    super.dispose();
  }

  bool _ispasswordValid() {
    return _password.isNotEmpty &&
        _password.length >= 8 &&
        _password.length <= 40;
  }

  bool _ispasswordEqual() {
    return _password.isNotEmpty &&
        _confirmpassword.isNotEmpty &&
        _password == _confirmpassword;
  }

  void _onNextTap() {
    if (!_ispasswordValid() || !_ispasswordEqual()) {
      return;
    }
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {
      ...state,
      "password": _password,
    };
    ref.read(signUpProvider.notifier).signUp(GoRouter.of(context));
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onClearTap() {
    _passwordController.clear();
  }

  void _onClearConfirmTap() {
    _confirmpasswordController.clear();
  }

  void _toggleObscureText() {
    _obscureText = !_obscureText;
    setState(() {});
  }

  void _toggleObscureConfirmText() {
    _obscureConfirmText = !_obscureConfirmText;
    setState(() {});
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
                    "Password",
                    style: TextStyle(
                      fontSize: Sizes.size16 + Sizes.size2,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF003B46),
                    ),
                  ),
                  Gaps.v4,
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _onClearTap,
                            child: FaIcon(
                              FontAwesomeIcons.circleXmark,
                              color: Colors.grey.shade600,
                              size: Sizes.size20,
                            ),
                          ),
                          Gaps.h16,
                          GestureDetector(
                            onTap: _toggleObscureText,
                            child: FaIcon(
                              _obscureText
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              color: Colors.grey.shade600,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
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
                  Text(
                    "Your password must have:",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Sizes.size14,
                    ),
                  ),
                  Gaps.v10,
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: Sizes.size20,
                        color: _ispasswordValid() ? Colors.green : Colors.red,
                      ),
                      Gaps.h10,
                      Text(
                        "8 to 20 characters",
                      ),
                    ],
                  ),
                  Gaps.v28,
                  Text(
                    "Confirm password",
                    style: TextStyle(
                      fontSize: Sizes.size16 + Sizes.size2,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF003B46),
                    ),
                  ),
                  Gaps.v4,
                  TextField(
                    controller: _confirmpasswordController,
                    obscureText: _obscureConfirmText,
                    decoration: InputDecoration(
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _onClearConfirmTap,
                            child: FaIcon(
                              FontAwesomeIcons.circleXmark,
                              color: Colors.grey.shade600,
                              size: Sizes.size20,
                            ),
                          ),
                          Gaps.h16,
                          GestureDetector(
                            onTap: _toggleObscureConfirmText,
                            child: FaIcon(
                              _obscureConfirmText
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              color: Colors.grey.shade600,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
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
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: Sizes.size20,
                        color: _ispasswordEqual() ? Colors.green : Colors.red,
                      ),
                      Gaps.h10,
                      Text(
                        "matching password",
                      ),
                    ],
                  ),
                  Gaps.v28,
                  GestureDetector(
                    onTap: _onNextTap,
                    child: SignUpNextButton(
                        disabled: !_ispasswordValid() || !_ispasswordEqual()),
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
