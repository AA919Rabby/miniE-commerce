import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {

  var selectedImagePath = ''.obs;
  var username = ''.obs;
  var profileImageBase64 = ''.obs;
  var isProfileLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }


  Future<void> getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 25);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  Future<void> saveProfileData(String name) async {
    try {
      isProfileLoading.value = true;
      String uid = _auth.currentUser!.uid;
      String imageAsString = profileImageBase64.value;


      if (selectedImagePath.value.isNotEmpty) {
        File file = File(selectedImagePath.value);
        List<int> imageBytes = await file.readAsBytes();
        imageAsString = base64Encode(imageBytes);
      }


      await _firestore.collection('users').doc(uid).set({
        'username': name,
        'image_base64': imageAsString,
        'email': _auth.currentUser?.email ?? '',
      });


      username.value = name;
      profileImageBase64.value = imageAsString;
      selectedImagePath.value = '';

      Get.snackbar('Success', 'Profile Saved Successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save: $e');
    } finally {
      isProfileLoading.value = false;
    }
  }


  void fetchProfileData() async {
    try {
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          username.value = data['username'] ?? '';
          profileImageBase64.value = data['image_base64'] ?? '';
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }


  ImageProvider getProfileImage() {
    if (selectedImagePath.value.isNotEmpty) {
      return FileImage(File(selectedImagePath.value));
    } else if (profileImageBase64.value.isNotEmpty) {
      return MemoryImage(base64Decode(profileImageBase64.value));
    } else {
      return const AssetImage('assets/placeholder.png');
    }
  }
}