import 'package:omnisight/constants/sizes.dart';
import 'package:flutter/material.dart';

class SignUpNextButton extends StatelessWidget {
  const SignUpNextButton({
    super.key,
    required this.disabled,
  });

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(vertical: Sizes.size14),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade500 : Color(0xFF003B46),
        ),
        duration: Duration(milliseconds: 200),
        child: Text(
          "Next",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFFF0F0F0),
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16),
        ),
      ),
    );
  }
}
