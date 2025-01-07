import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisight/constants/sizes.dart';
import 'package:omnisight/features/home/car/realtime_database.dart';

class CarPhotosScreen extends ConsumerStatefulWidget {
  static String routeURL = "/carphotos";
  final String carId;

  const CarPhotosScreen({super.key, required this.carId});

  @override
  ConsumerState<CarPhotosScreen> createState() => _CarPhotosScreenState();
}

class _CarPhotosScreenState extends ConsumerState<CarPhotosScreen> {
  @override
  void initState() {
    super.initState();
    fetchPhoto();
  }

  Uint8List? imageBytes;

  Future<void> fetchPhoto() async {
    RealtimeDatabase database = RealtimeDatabase();
    String? base64Image = await database.fetchMostRecentPhoto(widget.carId);

    if (base64Image != null) {
      setState(() {
        imageBytes = base64Decode(base64Image.split(',').last);
      });
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
          "Captured photos",
          style: TextStyle(
            fontSize: Sizes.size24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: imageBytes != null
            ? Image.memory(imageBytes!)
            : CircularProgressIndicator(),
      ),
    );
  }
}
