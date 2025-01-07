import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/features/home/car/car_screen.dart';
import 'package:omnisight/features/home/user/user_add_screen.dart';
import 'package:omnisight/features/home/user/user_profile_notifier.dart';
import 'package:omnisight/features/home/widgets/add_button.dart';
import 'package:omnisight/features/home/widgets/user_profile_widget.dart';

import '../../setting/setting_screen.dart';

class UserScreen extends ConsumerStatefulWidget {
  final GoRouterState routerState;
  static String routeURL = "/user";

  const UserScreen({super.key, required this.routerState});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  void _onSettingTap(BuildContext context) {
    context.push(SettingScreen.routeURL);
  }

  void _onCarTap(BuildContext context) {
    context.pop();
  }

  List<String> profileList = [];

  Future<void> getUserNames() async {
    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser == null) {
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(curUser.uid)
          .collection("userProfiles")
          .get();

      List<String> fetchedUserNames = [];

      for (var doc in snapshot.docs) {
        fetchedUserNames.add(doc.id);
      }

      if (mounted) {
        setState(() {
          profileList = fetchedUserNames;
        });
      }
    } catch (e) {
      print("Error fetching user profiles: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserNames();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserNames();
  }

  @override
  Widget build(BuildContext context) {
    final userProfiles = ref.watch(userProfilesProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003B46),
        foregroundColor: const Color(0xFFF0F0F0),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.size12),
          child: Row(
            children: [
              Image(
                image: AssetImage("assets/logowhite.png"),
                width: Sizes.size32,
              ),
              Gaps.h10,
              Text(
                "The Eye",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF0F0F0),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => _onSettingTap(context),
                child: FaIcon(
                  FontAwesomeIcons.gear,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Gaps.v28,
          for (int i = 0; i < userProfiles.userNames.length; i++) ...[
            UserProfileWidget(
              profileName: userProfiles.userNames[i],
              onDelete: () => ref
                  .read(userProfilesProvider.notifier)
                  .deleteUserProfile(userProfiles.userNames[i]),
            ),
            Gaps.v20,
          ],
          AddButton(
            addText: "user",
            destination: UserAddScreen.routeURL,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF003B46),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
              horizontal: 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onCarTap(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.car,
                          size: Sizes.size24 + Sizes.size2,
                          color: widget.routerState.matchedLocation ==
                                  CarScreen.routeURL
                              ? Colors.grey.shade300
                              : Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidUser,
                        size: Sizes.size24 + Sizes.size2,
                        color: widget.routerState.matchedLocation ==
                                UserScreen.routeURL
                            ? Colors.grey.shade300
                            : Colors.grey.shade500,
                      ),
                    ],
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
