import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/models/product_model.dart';
import 'package:e_commerce/services/products_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductsControllers extends GetxController {
  ProductsServices productsServices = ProductsServices();


  List<ProductModel> products = [];
  List<ProductModel> carts = [];

  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    getProducts();
    loadCartFromFirebase();
    super.onInit();
  }

  getProducts() async {
    try {
      isLoading = true;
      update();
      http.Response response = await productsServices.getProducts();
      print('code ${response.statusCode}');
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        for (int i = 0; i < result.length; i++) {
          products.add(ProductModel.fromJson(result[i]));
        }
        isLoading = false;
        update();
      } else
        print('bad gateway ${response.statusCode}');
    } catch (e) {
      print(e.toString());
    }
  }

  addToCart(ProductModel product) async {
    carts.add(product);
    update();
    try {
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('my_cart')
            .doc(product.id.toString())
            .set(product.toJson());
      }
    } catch (e) {
      print("Error adding to firebase: $e");
    }
  }


  removeFromCart(ProductModel product) async {
    carts.removeWhere((item) => item.id == product.id);
    update();

    try {
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('my_cart')
            .doc(product.id.toString())
            .delete();
      }
    } catch (e) {
      print("Error deleting from cart: $e");
    }
  }

  saveCartSelection(ProductModel product, int size, int quantity) async {
    try {
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('my_cart')
            .doc(product.id.toString())
            .update({
          'size': size,
          'quantity': quantity,
        });
      }
    } catch (e) {
      print("Error saving cart data: $e");
    }
  }

  void loadCartFromFirebase() async {
    try {
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        var snapshot =
        await _firestore.collection('users').doc(uid).collection('my_cart').get();

        carts.clear();
        for (var doc in snapshot.docs) {
          carts.add(ProductModel.fromJson(doc.data()));
        }
        update();
      }
    } catch (e) {
      print("Error loading cart: $e");
    }
  }
}
