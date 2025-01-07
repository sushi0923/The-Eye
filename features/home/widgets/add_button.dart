import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/constants/sizes.dart';

class AddButton extends StatelessWidget {
  final String addText;
  final String destination;

  const AddButton({
    super.key,
    required this.addText,
    required this.destination,
  });

  void _onAddCarTap(BuildContext context) {
    context.push(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Sizes.size36 + Sizes.size2),
      child: GestureDetector(
        onTap: () => {
          _onAddCarTap(context),
        },
        child: DottedBorder(
          color: Color(0xFF003B46),
          strokeWidth: Sizes.size2,
          dashPattern: [Sizes.size4, Sizes.size6],
          borderType: BorderType.RRect,
          radius: Radius.circular(Sizes.size12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.size12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.plus,
                  color: Color(0xFF003B46),
                ),
                Gaps.h10,
                Text(
                  "Add $addText",
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003B46),
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
