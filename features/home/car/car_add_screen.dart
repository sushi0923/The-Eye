import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisight/constants/gaps.dart';
import 'package:omnisight/constants/sizes.dart';

class CarAddScreen extends StatefulWidget {
  static String routeURL = "/caradd";
  const CarAddScreen({super.key});

  @override
  State<CarAddScreen> createState() => _CarAddScreenState();
}

class _CarAddScreenState extends State<CarAddScreen> {
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carIdController = TextEditingController();

  String _carName = "";
  String _carId = "";
  String? _errorText;

  @override
  void initState() {
    super.initState();

    _carNameController.addListener(() {
      setState(() {
        _carName = _carNameController.text.trim();
      });
    });

    _carIdController.addListener(() {
      setState(() {
        _carId = _carIdController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _carNameController.dispose();
    _carIdController.dispose();
    super.dispose();
  }

  Future<void> _onCreateTap() async {
    if (_carName.isEmpty || _carId.isEmpty) {
      setState(() {
        _errorText = "Car name and hardware ID cannot be empty.";
      });
      return;
    }

    User? curUser = FirebaseAuth.instance.currentUser;

    if (curUser != null) {
      DocumentReference carProfileDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(curUser.uid)
          .collection("carProfiles")
          .doc(_carName);

      try {
        await carProfileDoc.set({
          "carId": _carId,
        });

        if (mounted) {
          context.pop();
        }
      } catch (e) {
        setState(() {
          _errorText = "Failed to create car profile. Try again.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003B46),
        foregroundColor: const Color(0xFFF0F0F0),
        title: const Text(
          "Add Car",
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
              "Car profile name",
              style: TextStyle(
                fontSize: Sizes.size16 + Sizes.size2,
                fontWeight: FontWeight.w500,
                color: Color(0xFF003B46),
              ),
            ),
            Gaps.v4,
            TextField(
              controller: _carNameController,
              decoration: InputDecoration(
                hintText: "Set car profile name",
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
            Gaps.v28,
            const Text(
              "Hardware ID",
              style: TextStyle(
                fontSize: Sizes.size16 + Sizes.size2,
                fontWeight: FontWeight.w500,
                color: Color(0xFF003B46),
              ),
            ),
            Gaps.v4,
            TextField(
              controller: _carIdController,
              decoration: InputDecoration(
                hintText: "Enter hardware ID",
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
                    color: _carName.isNotEmpty && _carId.isNotEmpty
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
                      "Create Car Profile",
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
