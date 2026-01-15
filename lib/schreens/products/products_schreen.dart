import 'package:e_commerce/const/allcolors.dart';
import 'package:e_commerce/controllers/products_controllers.dart';
import 'package:e_commerce/controllers/profile_controller.dart';
import 'package:e_commerce/models/product_model.dart';
import 'package:e_commerce/schreens/cart/cart_schreen.dart';
import 'package:e_commerce/schreens/products/products_details.dart';
import 'package:e_commerce/schreens/settings/setting_schreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});

  ProductsControllers productsControllers = Get.put(ProductsControllers());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Products',
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
        backgroundColor:AllColors.primaryColor,
        toolbarHeight: 60,
        leading: Builder(
          builder: (context) => Tooltip(
            message: 'My profile',
            child: IconButton(
              icon: Icon(Icons.menu_open, color: Colors.white, size: 32),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(CartSchreen());
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.orange.withOpacity(.7),
              size: 32,
            ),
          ),
          SizedBox(width: 18),
          InkWell(
            onTap: () {
              Get.to(SettingSchreen());
            },
            child: Icon(
              Icons.settings,
              color: Colors.black87.withOpacity(.7),
              size: 32,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Obx(() {
              bool hasImage = profileController.selectedImagePath.value.isNotEmpty ||
                  profileController.profileImageBase64.value.isNotEmpty;

              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(color:AllColors.primaryColor),
                accountName: Text (
                  profileController.username.value.isEmpty
                      ? "Guest User"
                      : profileController.username.value,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                accountEmail: null,
                currentAccountPicture: CircleAvatar (
                  backgroundColor: Colors.white,
                  backgroundImage: hasImage ? profileController.getProfileImage() : null,
                  child: hasImage
                      ? null
                      : Icon(Icons.person, size: 50, color: Colors.grey),
                ),
              );
            }),
          ],
        ),
      ),

      body: GetBuilder<ProductsControllers>(
        builder: (_) {
          return productsControllers.isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
            itemCount: productsControllers.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              ProductModel product = productsControllers.products[index];
              return InkWell(
                onTap: () {
                  Get.to(
                    ProductsDetails(),
                    arguments: {'product': product},
                  );
                },
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(.5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Image.network(
                          product.image!,
                          height: 160,
                          width: 200,
                        ),
                        SizedBox(height: 2),
                        Text(
                          product.title!,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text('\$'),
                                  SizedBox(width: 3),
                                  Text(product.price!.toString()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  SizedBox(width: 3),
                                  Text(product.rating!.rate.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}