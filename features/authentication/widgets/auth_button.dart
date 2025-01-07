import 'package:flutter/material.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final FaIcon icon;

  const AuthButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Sizes.size24, horizontal: Sizes.size16),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(alignment: Alignment.centerLeft, child: icon),
            Positioned.fill(
              // Make text fill the available space
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Sizes.size16 + Sizes.size2,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
