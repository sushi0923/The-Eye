import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarProfile {
  final List<String> carNames;
  final List<String> carIds;

  CarProfile({required this.carNames, required this.carIds});
}

class CarProfileNotifier extends StateNotifier<CarProfile> {
  CarProfileNotifier() : super(CarProfile(carNames: [], carIds: [])) {
    fetchCarProfiles();
  }

  Future<void> fetchCarProfiles() async {
    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(curUser.uid)
          .collection("carProfiles")
          .snapshots()
          .listen((snapshot) {
        List<String> carNames = [];
        List<String> carIds = [];

        for (var doc in snapshot.docs) {
          carNames.add(doc.id);
          carIds.add(doc["carId"]);
        }

        state = CarProfile(carNames: carNames, carIds: carIds);
      });
    }
  }

  Future<void> addCarProfile(String carName, String carId) async {
    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser != null) {
      DocumentReference carProfileDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(curUser.uid)
          .collection("carProfiles")
          .doc(carName);

      try {
        await carProfileDoc.set({
          "carId": carId,
        });

        await fetchCarProfiles();
      } catch (e) {
        print("Error adding car profile: $e");
      }
    }
  }

  Future<void> deleteCarProfile(String carName) async {
    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser != null) {
      try {
        DocumentReference carProfileDoc = FirebaseFirestore.instance
            .collection("users")
            .doc(curUser.uid)
            .collection("carProfiles")
            .doc(carName);

        await carProfileDoc.delete();

        await fetchCarProfiles();
      } catch (e) {
        print("Error deleting car profile: $e");
      }
    } else {
      print("User is not logged in.");
    }
  }
}

final carProfilesProvider =
    StateNotifierProvider<CarProfileNotifier, CarProfile>(
  (ref) => CarProfileNotifier(),
);
