import 'package:e_commerce/const/allcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/details_controllers.dart';

class HistorySchreen extends StatefulWidget {
  const HistorySchreen({super.key});

  @override
  State<HistorySchreen> createState() => _HistorySchreenState();
}

class _HistorySchreenState extends State<HistorySchreen> {
  final DetailsController controller = Get.put(DetailsController());

  @override
  void initState() {
    super.initState();
    controller.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment History',
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor:AllColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              showClearHistoryDialog();
            },
            icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
            tooltip: "Clear History",
          )
        ],
      ),
      body: Obx(() {
        if (controller.historyList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text("No history available",
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.historyList.length,
          itemBuilder: (context, index) {
            var data = controller.historyList[index];

            String method = data['paymentMethod'] ?? "Unknown";
            bool isBinance = method == "Binance";
            Color methodColor = isBinance ? Colors.orange : Colors.blue;
            IconData methodIcon = isBinance ? Icons.currency_bitcoin : Icons.paypal;

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['image'] ?? "https://via.placeholder.com/50",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image_not_supported),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'] ?? "Product Name",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "${data['date']} at ${data['time']}",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: methodColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(methodIcon, color: methodColor, size: 20),
                            ),
                            SizedBox(height: 4),
                            Text(method, style: TextStyle(fontSize: 10, color: methodColor, fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    ),
                    Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoColumn("Size", "${data['size']}"),
                        infoColumn("Qty", "${data['quantity']}"),
                        infoColumn("Price", "\$${data['price']}"),
                        infoColumn("Delivery", "\$${data['deliveryCharge']}"),
                      ],
                    ),
                    SizedBox(height: 10),

                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blueGrey.withOpacity(0.2))
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Cost:", style: TextStyle(fontWeight: FontWeight.w600)),
                              Text("\$${data['totalCost']?.toStringAsFixed(2)}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Paid (20%):", style: TextStyle(color: Colors.green)),
                              Text("\$${data['paidAmount']?.toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Dues:", style: TextStyle(color: Colors.red)),
                              Text("\$${data['dueAmount']?.toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

      infoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

    showClearHistoryDialog() {
    Get.dialog(
      AlertDialog (
        title: Text("Clear History"),
        content: Text("Are you sure you want to remove all payment history?"),
        actions: [
          TextButton (onPressed: () => Get.back(), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.clearHistory();
            },
            child: Text ("Remove", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}