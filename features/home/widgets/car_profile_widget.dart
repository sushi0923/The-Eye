import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/features/home/car/car_photos_screen.dart';
import 'package:omnisight/features/home/car/realtime_database.dart';
import 'package:url_launcher/url_launcher.dart';

class CarProfileWidget extends StatelessWidget {
  final String profileName;
  final String profileId;
  final VoidCallback onDelete;

  const CarProfileWidget(
      {super.key,
      required this.profileName,
      required this.onDelete,
      required this.profileId});

  Future<void> _openMap(String carId) async {
    RealtimeDatabase database = RealtimeDatabase();

    Map<String, dynamic>? gpsData = await database.fetchMostRecentGPS(carId);
    print(gpsData);

    if (gpsData != null) {
      String latitude = gpsData['latitude'];
      String longitude = gpsData['longitude'];

      String googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
      } else {
        print("Could not launch $googleMapsUrl");
      }
    } else {
      print("GPS data not available for this car.");
    }
  }

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
                            FontAwesomeIcons.carSide,
                            color: Color(0xFFF0F0F0),
                          ),
                          Gaps.h10,
                          Text(
                            "Car profile",
                            style: TextStyle(
                              color: Color(0xFFF0F0F0),
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.size16,
                            ),
                          ),
                        ],
                      ),
                      Gaps.v6,
                      Row(
                        children: [
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
                          Gaps.h24,
                          GestureDetector(
                            onTap: () => {
                              _openMap(profileId),
                            },
                            child: FaIcon(
                              FontAwesomeIcons.mapLocationDot,
                              color: Color(0xFFF0F0F0),
                              size: Sizes.size32,
                            ),
                          ),
                          Gaps.h24,
                          GestureDetector(
                            onTap: () => {
                              context.push(
                                  "${CarPhotosScreen.routeURL}/$profileId"),
                            },
                            child: FaIcon(
                              FontAwesomeIcons.image,
                              color: Color(0xFFF0F0F0),
                              size: Sizes.size32,
                            ),
                          ),
                        ],
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
                              "This will permanently delete this Car profile."),
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
