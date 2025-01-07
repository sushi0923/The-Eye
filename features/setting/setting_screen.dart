import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisight/common/notification_config.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/features/authentication/repos/authentication_repos.dart';

class SettingScreen extends ConsumerWidget {
  static String routeURL = "/setting";

  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003B46),
        foregroundColor: const Color(0xFFF0F0F0),
        title: const Text(
          "Setting",
          style: TextStyle(
            fontSize: Sizes.size24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
        child: ListView(
          children: [
            Gaps.v10,
            AnimatedBuilder(
              animation: notificationConfig,
              builder: (context, child) => SwitchListTile.adaptive(
                value: notificationConfig.autoNotification,
                onChanged: (value) {
                  if (!value) {
                    // Show the dialog only when the user is turning the tile off
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text("Are you sure?"),
                          content: Text(
                            "You will NOT be able to receive any notification, and OmniSight will not be able to protect your car?",
                          ),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                              },
                              child: Text("No"),
                            ),
                            CupertinoDialogAction(
                              onPressed: () {
                                notificationConfig
                                    .toggleAutoNotification(); // Update the state
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                              },
                              isDestructiveAction: true,
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // If the user is turning it on, toggle immediately
                    notificationConfig.toggleAutoNotification();
                  }
                },
                title: Text(
                  "Enable Omnisight",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Sizes.size16 + Sizes.size2,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () => showAboutDialog(context: context),
              title: Text(
                "App info",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Sizes.size16 + Sizes.size2,
                ),
              ),
              subtitle: Text("About this app"),
            ),
            ListTile(
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text("Are you sure?"),
                    content: Text("This will send you to the sign up screen."),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("No"),
                      ),
                      CupertinoDialogAction(
                        onPressed: () => ref.read(authRepo).signOut(),
                        isDestructiveAction: true,
                        child: Text("Yes"),
                      )
                    ],
                  ),
                );
              },
              title: Text(
                "Sign out",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: Sizes.size16 + Sizes.size2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
