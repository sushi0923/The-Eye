import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/features/home/car/car_add_screen.dart';
import 'package:omnisight/features/home/car/car_profile_notifier.dart';
import 'package:omnisight/features/home/user/user_screen.dart';
import 'package:omnisight/features/home/widgets/add_button.dart';
import 'package:omnisight/features/home/widgets/car_profile_widget.dart';
import 'package:omnisight/features/setting/setting_screen.dart';

class CarScreen extends ConsumerStatefulWidget {
  final GoRouterState routerState;
  static String routeURL = "/car";

  const CarScreen({super.key, required this.routerState});

  @override
  ConsumerState<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends ConsumerState<CarScreen> {
  void _onSettingTap(BuildContext context) {
    context.push(SettingScreen.routeURL);
  }

  void _onUserTap(BuildContext context) {
    context.push(UserScreen.routeURL);
  }

  List<String> profileList = [];

  Future<String> fetchCarIdByProfileName(carProfileName) async {
    User? curUser = FirebaseAuth.instance.currentUser;
    DocumentReference carProfileDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(curUser!.uid)
        .collection("carProfiles")
        .doc(carProfileName);

    DocumentSnapshot snapshot = await carProfileDoc.get();

    String carId = snapshot.get('carId');
    return carId;
  }

  Future<void> getCarNames() async {
    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser == null) {
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(curUser.uid)
          .collection("carProfiles")
          .get();

      List<String> fetchedCarNames = [];

      for (var doc in snapshot.docs) {
        fetchedCarNames.add(doc.id);
      }

      if (mounted) {
        setState(() {
          profileList = fetchedCarNames;
        });
      }
    } catch (e) {
      print("Error fetching car profiles: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getCarNames();
    requestPermission().then((_) {
      getToken();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  late final CarProfile carProfiles;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCarNames();
  }

  String? mtoken = "";

  void getToken() async {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    print("APNS Token: $apnsToken");

    if (apnsToken != null) {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        setState(() {
          mtoken = token;
          print("FCM Token: $mtoken");
        });
        saveToken(token);
      }
    } else {
      print(
          "APNS Token not available. Ensure notifications are enabled in device settings.");
    }
  }

  Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void saveToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set({'token': token});
  }

  @override
  Widget build(BuildContext context) {
    final carProfiles = ref.watch(carProfilesProvider);

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
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
          for (int i = 0; i < carProfiles.carNames.length; i++) ...[
            CarProfileWidget(
              profileName: carProfiles.carNames[i],
              profileId: carProfiles.carIds[i],
              onDelete: () => ref
                  .read(carProfilesProvider.notifier)
                  .deleteCarProfile(carProfiles.carNames[i]),
            ),
            Gaps.v20,
          ],
          AddButton(
            addText: "car",
            destination: CarAddScreen.routeURL,
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
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onUserTap(context),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
