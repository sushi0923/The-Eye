import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/constants/sizes.dart';

class UserProfileWidget extends StatelessWidget {
  final String profileName;
  final VoidCallback onDelete;

  const UserProfileWidget(
      {super.key, required this.profileName, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF003B46),
          borderRadius: BorderRadius.circular(Sizes.size12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size14, vertical: Sizes.size10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.user,
                            color: Color(0xFFF0F0F0),
                          ),
                          Gaps.h10,
                          Text(
                            "User profile",
                            style: TextStyle(
                              color: Color(0xFFF0F0F0),
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.size16,
                            ),
                          ),
                        ],
                      ),
                      Gaps.v6,
                      Text(
                        profileName,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFF0F0F0),
                          color: Color(0xFFF0F0F0),
                          fontWeight: FontWeight.w400,
                          fontSize: Sizes.size36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text("Are you sure?"),
                          content: Text(
                              "This will permanently delete this user profile."),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => context.pop(),
                              child: Text("cancel"),
                            ),
                            CupertinoDialogAction(
                              onPressed: () => {
                                onDelete(),
                                context.pop(),
                              },
                              isDestructiveAction: true,
                              child: Text("delete"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: FaIcon(
                      FontAwesomeIcons.trash,
                      color: Color(0xFFF0F0F0),
                      size: Sizes.size28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
