import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RealtimeDatabase {
  final DatabaseReference _carProfilesRef =
      FirebaseDatabase.instance.ref("carProfiles");

  Stream<String?> streamMostRecentPhoto(String carId) {
    DatabaseReference photosRef = _carProfilesRef.child("$carId/photos");

    return photosRef.onValue.map((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        MapEntry<dynamic, dynamic> mostRecentEntry = data.entries.last;

        return mostRecentEntry.value['image'] as String?;
      } else {
        print("No photo data found.");
        return null;
      }
    });
  }

  Future<Map<String, dynamic>?> fetchMostRecentGPS(String carId) async {
    try {
      DatabaseReference gpsDataRef = _carProfilesRef.child("$carId/gps_data");

      DatabaseEvent event = await gpsDataRef.limitToLast(1).once();

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        MapEntry<dynamic, dynamic> mostRecentEntry = data.entries.last;

        Map<String, dynamic> gpsData =
            Map<String, dynamic>.from(mostRecentEntry.value);

        return gpsData;
      } else {
        print("No GPS data found.");
        return null;
      }
    } catch (e) {
      print("Error fetching GPS data: $e");
      return null;
    }
  }

  Future<String?> fetchMostRecentPhoto(String carId) async {
    try {
      DatabaseReference photosRef = _carProfilesRef.child("$carId/photos");

      DatabaseEvent event = await photosRef.limitToLast(1).once();

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        MapEntry<dynamic, dynamic> mostRecentEntry = data.entries.first;

        print(mostRecentEntry.value['timestamp']);

        return mostRecentEntry.value['image'] as String?;
      } else {
        print("No photo data found.");
        return null;
      }
    } catch (e) {
      print("Error fetching photo data: $e");
      return null;
    }
  }
}

final photoStreamProvider =
    StreamProvider.family<String?, String>((ref, carId) {
  final database = RealtimeDatabase();
  return database.streamMostRecentPhoto(carId);
});
