import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/schreens/products/products_schreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../schreens/auth/login_schreen.dart';

class DetailsController extends GetxController {

  final savedKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();
  final registerKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();

  final walletController = TextEditingController();
  final trxController = TextEditingController();
  final save = TextEditingController();
  final email = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var historyList = [].obs;

  @override
  void onInit() {
    super.onInit();
    getHistory();
  }

  void login() async {
    if (loginKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await auth.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        isLoading.value = false;
        Get.offAll(ProductsScreen());
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        Get.snackbar('Error', e.message ?? 'Invalid email or password');
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Error', 'Something went wrong');
      }
    }
  }

  register() async {
    if (registerKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await auth.createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        isLoading.value = false;
        Get.offAll(ProductsScreen());
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        Get.snackbar('Error', 'The email address already in use by another account');
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Error', 'Something went wrong');
      }
    }
  }

  void saved() async {
    if (savedKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        isLoading.value = false;
        Get.offAll(ProductsScreen());
      } catch (e) {
        isLoading.value = false;
      }
    }
  }

  void sendPasswordResetEmail() async {
    if (email.text.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter your email address to reset password",
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    }

    try {
      await auth.sendPasswordResetEmail(email: email.text.trim());
      Get.back();
      Get.snackbar(
        "Success",
        "Password reset link sent to ${email.text}. Check your email.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Error sending reset email");
    }
  }

  Future<void> addToHistory(Map<String, dynamic> orderData) async {
    try {
      if (auth.currentUser != null) {
        String uid = auth.currentUser!.uid;
        await firestore.collection('users').doc(uid).collection('history').add(orderData);
        getHistory();
      }
    } catch (e) {
      print("Error saving history: $e");
    }
  }

  Future<void> getHistory() async {
    try {
      if (auth.currentUser != null) {
        String uid = auth.currentUser!.uid;
        QuerySnapshot snapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('history')
            .orderBy('timestamp', descending: true)
            .get();

        historyList.value = snapshot.docs.map((doc) => doc.data()).toList();
        update();
      }
    } catch (e) {
      print("Error fetching history: $e");
    }
  }

  Future<void> clearHistory() async {
    try {
      if (auth.currentUser != null) {
        String uid = auth.currentUser!.uid;
        var collection = firestore.collection('users').doc(uid).collection('history');
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
        historyList.clear();
        update();
        Get.back();
        Get.snackbar("Success", "History cleared successfully");
      }
    } catch (e) {
      print("Error clearing history: $e");
    }
  }


 void checkUser(){
    final user=FirebaseAuth.instance.currentUser;
    if(user !=null){
      Get.offAll(ProductsScreen());
    }else{
      Get.offAll(LoginSchreen());
    }
  }

}