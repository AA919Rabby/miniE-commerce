import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/const/allcolors.dart';
import 'package:e_commerce/controllers/products_controllers.dart';
import 'package:e_commerce/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../controllers/details_controllers.dart';

class CartSchreen extends StatefulWidget {
  const CartSchreen({super.key});

  @override
  State<CartSchreen> createState() => _CartSchreenState();
}

class _CartSchreenState extends State<CartSchreen> {
  ProductsControllers productsControllers = Get.put(ProductsControllers());
  final controller = Get.put(DetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' My Carts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:AllColors.primaryColor,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<ProductsControllers>(
        builder: (_) {
          if (productsControllers.carts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart,
                      size: 80, color: Colors.orange.withOpacity(.7)),
                  SizedBox(height: 20),
                  Text(
                    "Your cart is empty",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Add some products to see them here",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: productsControllers.carts.length,
            itemBuilder: (context, index) {
              return cartProductView(productsControllers.carts[index]);
            },
          );
        },
      ),
    );
  }
 //helper widget
  cartProductView(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            onTap: () {
              openSizeQtyDialog(product);
            },
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                product.image ?? "https://via.placeholder.com/150",
              ),
            ),
            title: Text(
              product.title ?? "No Title",
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              product.description ?? "No Description",
              overflow: TextOverflow.ellipsis,
            ),
            trailing: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Card(
                elevation: 3,
                child: IconButton(
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    productsControllers.removeFromCart(product);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//helper widget
  void openSizeQtyDialog(ProductModel product) {
    int selectedSize = 20;
    int selectedQty = 1;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Size & Quantity'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: selectedSize,
                    isExpanded: true,
                    items: List.generate(
                      81,
                          (index) {
                        int size = 20 + index;
                        return DropdownMenuItem(
                          value: size,
                          child: Text(size.toString()),
                        );
                      },
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value!;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButton<int>(
                    value: selectedQty,
                    isExpanded: true,
                    items: List.generate(
                      10,
                          (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedQty = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                productsControllers.saveCartSelection(
                  product,
                  selectedSize,
                  selectedQty,
                );
                Get.back();
                openPaymentSelectionDialog(product, selectedSize, selectedQty);
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

//helper widget
  void openPaymentSelectionDialog(ProductModel product, int size, int quantity) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.paypal, color: Colors.blue, size: 40),
                title: Text("PayPal"),
                subtitle: Text("Pay via PayPal ID"),
                onTap: () {
                  Get.back();
                  openGenericPaymentDialog(product, size, quantity, "PayPal");
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.currency_bitcoin, color: Colors.orange, size: 40),
                title: Text("Binance"),
                subtitle: Text("Pay via Binance Pay/UID"),
                onTap: () {
                  Get.back();
                  openGenericPaymentDialog(product, size, quantity, "Binance");
                },
              ),
            ],
          ),
        );
      },
    );
  }
//helper widget
  void openGenericPaymentDialog(ProductModel product, int size, int quantity, String method) {

    double deliveryCharge = 20.0;
    double price = (product.price ?? 0).toDouble();
    double totalCost = (price * quantity) + deliveryCharge;


    double paidAmount = totalCost * 0.20;
    double dueAmount = totalCost - paidAmount;

    String randomReceiverId = method == "PayPal"
        ? "business${Random().nextInt(999)}@paypal.com"
        : "UID-${Random().nextInt(999999999)}";

    String inputLabel = method == "PayPal" ? "Your PayPal ID" : "Your Binance UID";
    Color methodColor = method == "PayPal" ? Colors.blue : Colors.orange;
    IconData methodIcon = method == "PayPal" ? Icons.paypal : Icons.currency_bitcoin;

    controller.walletController.clear();
    controller.trxController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(methodIcon, color: methodColor),
              SizedBox(width: 10),
              Text('$method Payment'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Cost: \$${(price * quantity).toStringAsFixed(2)}"),
                Text("Delivery Charge: \$${deliveryCharge.toStringAsFixed(2)}"),
                Divider(),
                Text("Total Total: \$${totalCost.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Pay 20% Now: \$${paidAmount.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                Text("Due After Payment: \$${dueAmount.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.red)),

                SizedBox(height: 15),
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Send amount to ($method):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        SelectableText(randomReceiverId, style: TextStyle(fontSize: 14, color: Colors.black87)),
                      ],
                    )
                ),
                SizedBox(height: 15),
                TextField(
                  controller: controller.walletController,
                  decoration: InputDecoration(
                      labelText: inputLabel,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: methodColor)
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controller.trxController,
                  decoration: InputDecoration(
                      labelText: "Transaction ID",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.receipt_long, color: methodColor)
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: methodColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (controller.walletController.text.trim().isEmpty ||
                    controller.trxController.text.trim().isEmpty) {
                  Get.snackbar(
                      'Error', 'Fields cannot be empty');
                  return;
                }

                Get.back();

                Map<String, dynamic> orderData = {
                  "title": product.title,
                  "image": product.image,
                  "price": product.price,
                  "quantity": quantity,
                  "size": size,
                  "deliveryCharge": deliveryCharge,
                  "totalCost": totalCost,
                  "paidAmount": paidAmount,
                  "dueAmount": dueAmount,
                  "transactionId": controller.trxController.text,
                  "paymentMethod": method,
                  "date": DateTime.now().toString().split(' ')[0],
                  "time": DateTime.now().toString().split(' ')[1].substring(0, 5),
                  "timestamp": FieldValue.serverTimestamp(),
                };

                controller.addToHistory(orderData);


                Get.dialog(
                  AlertDialog(
                    title:
                    Icon(Icons.check_circle, color: Colors.green, size: 50),
                    content: Text(
                      "Payment Successful\nvia $method",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    actions: [
                      Card(
                        elevation: 3,
                        shadowColor: Colors.black.withOpacity(.5),
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Done'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}