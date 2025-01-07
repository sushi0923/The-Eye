import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final List<String> userNames;

  UserProfile({required this.userNames});
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile(userNames: [])) {
    fetchUserProfiles();
  }

  Future<void> fetchUserProfiles() async {
    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(curUser.uid)
          .collection("userProfiles")
          .snapshots()
          .listen((snapshot) {
        List<String> userNames = [];

        for (var doc in snapshot.docs) {
          userNames.add(doc.id);
        }

        state = UserProfile(userNames: userNames);
      });
    }
  }

  Future<void> addUserProfile(String userName) async {
    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser != null) {
      DocumentReference userProfileDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(curUser.uid)
          .collection("userProfiles")
          .doc(userName);

      try {
        await userProfileDoc.set({});

        await fetchUserProfiles();
      } catch (e) {
        print("Error adding user profile: $e");
      }
    }
  }

  Future<void> deleteUserProfile(String userName) async {
    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser != null) {
      try {
        DocumentReference userProfileDoc = FirebaseFirestore.instance
            .collection("users")
            .doc(curUser.uid)
            .collection("userProfiles")
            .doc(userName);

        await userProfileDoc.delete();

        await fetchUserProfiles();
      } catch (e) {
        print("Error deleting user profile: $e");
      }
    }
  }
}

final userProfilesProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>(
  (ref) => UserProfileNotifier(),
);
