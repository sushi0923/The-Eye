class UserProfileModel {
  final String uid;

  UserProfileModel({
    required this.uid,
  });

  UserProfileModel.empty() : uid = "";

  toJson() {
    return {
      "uid": uid,
    };
  }
}
