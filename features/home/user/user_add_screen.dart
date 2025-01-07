import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/constants/sizes.dart';

class UserAddScreen extends StatefulWidget {
  static String routeURL = "/useradd";
  const UserAddScreen({super.key});

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  final TextEditingController _userNameController = TextEditingController();

  String _userName = "";
  String? _errorText;

  @override
  void initState() {
    super.initState();

    _userNameController.addListener(() {
      setState(() {
        _userName = _userNameController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _onCreateTap() async {
    if (_userName.isEmpty) {
      setState(() {
        _errorText = "User name cannot be empty.";
      });
      return;
    }

    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser != null) {
      DocumentReference userProfileDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(curUser.uid)
          .collection("userProfiles")
          .doc(_userName);

      await userProfileDoc.set(<String, dynamic>{});

      List<String> photoUrls = [];
      for (File image in _selectedImages) {
        final ref = FirebaseStorage.instance.ref().child(
            'user_photos/${curUser.uid}/${DateTime.now().toIso8601String()}');
        await ref.putFile(image);
        String downloadURL = await ref.getDownloadURL();
        photoUrls.add(downloadURL);
      }

      await userProfileDoc.update({
        'photoUrls': FieldValue.arrayUnion(photoUrls),
      });

      if (mounted) {
        context.pop();
      }
    }
  }

  List<File> _selectedImages = [];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _selectedImages.add(File(image.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003B46),
        foregroundColor: const Color(0xFFF0F0F0),
        title: const Text(
          "Add User",
          style: TextStyle(
            fontSize: Sizes.size24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v24,
            const Text(
              "User Name",
              style: TextStyle(
                fontSize: Sizes.size16 + Sizes.size2,
                fontWeight: FontWeight.w500,
                color: Color(0xFF003B46),
              ),
            ),
            Gaps.v4,
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                hintText: "Set user name",
                errorText: _errorText,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003B46)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003B46)),
                ),
              ),
              cursorColor: Colors.black,
            ),
            Gaps.v24,
            const Text(
              "User photos",
              style: TextStyle(
                fontSize: Sizes.size16 + Sizes.size2,
                fontWeight: FontWeight.w500,
                color: Color(0xFF003B46),
              ),
            ),
            Gaps.v14,
            for (int i = 1; i < _selectedImages.length + 1; i++) ...[
              Text(
                "Image $i",
                style: TextStyle(
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.v6,
            ],
            Gaps.v10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size2),
              child: GestureDetector(
                onTap: () => {
                  _pickImage(),
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
                          "Add photos",
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, Sizes.size20, 0, Sizes.size10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _onCreateTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: _userName.isNotEmpty
                        ? const Color(0xFF003B46)
                        : Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(Sizes.size12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Sizes.size6,
                      horizontal: Sizes.size14,
                    ),
                    child: Text(
                      "Create User Profile",
                      style: TextStyle(
                        color: Color(0xFFF0F0F0),
                        fontWeight: FontWeight.w500,
                        fontSize: Sizes.size20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
