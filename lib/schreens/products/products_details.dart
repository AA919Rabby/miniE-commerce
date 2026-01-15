import 'package:e_commerce/const/allcolors.dart';
import 'package:e_commerce/controllers/products_controllers.dart';
import 'package:e_commerce/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';


class ProductsDetails extends StatelessWidget {
   ProductsDetails({super.key});

  @override
  ProductsControllers productsControllers=Get.put(ProductsControllers());
  Widget build(BuildContext context) {

    ProductModel product=Get.arguments['product'];
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon (Icons.arrow_back,color: Colors.black,)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: (){
                Share.share("Hello! Sharing from AppBar.");
              },
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon (Icons.share_outlined,color: Colors.white,),
              )),
        ],
      ),

      
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        product.image!,
                        height: 200,
                        width: Get.width,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.title!,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('\$'),
                                const SizedBox(width: 3),
                                Text(product.price!.toString()),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AllColors.primaryColor,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 4, top: 4),
                              child: Text(
                                product.category!,
                                style: TextStyle(color: AllColors.whiteColor),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.star, color: Colors.orange, size: 16),
                                const SizedBox(width: 3),
                                Text(product.rating!.rate.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.description!,
                          style: TextStyle(color: Colors.black.withOpacity(0.7)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 7),
            child: InkWell(
              onTap: () {
                productsControllers.addToCart(product);
                Get.back();
              },
              child: Container(
                height: 60,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AllColors.primaryColor,
                ),
                child: Center(
                  child: Text(
                    'Add to cart',
                    style: TextStyle(color: AllColors.whiteColor, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
