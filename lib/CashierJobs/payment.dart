// ignore_for_file: non_constant_identifier_names

import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';

class Payment extends StatelessWidget {
  final VoidCallback handleChange;
  final void Function(int id, Map<String, dynamic> item, double sales)
  handlePayment;
  final List<dynamic> items;
  final String HotelName;
  const Payment({
    super.key,
    required this.handleChange,
    required this.handlePayment,
    required this.items,
    required this.HotelName,
  });

  @override
  Widget build(BuildContext context) {
    final unpaidItems = items
        .where(
          (item) =>
              ((item['payment'] != "Paid" || item['payment'] == "Cancelled") &&
              item['HotelName'] == HotelName),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 55),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: handleChange,
                  icon: Icon(Icons.arrow_back),
                  tooltip: "Handle Order",
                ),
                Text(
                  "Back to Order",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: unpaidItems.length,
              itemBuilder: (context, index) {
                final item = unpaidItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 130,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Apptheme.containerlogin,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Table No",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSerif",
                                color: Apptheme.mosttxtcolor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "${item['tableNo']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Waiter Name",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSerif",
                                color: Apptheme.mosttxtcolor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              item['waiterName'] ?? "",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Item Name",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSerif",
                                color: Apptheme.mosttxtcolor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "${item['title']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Total Price",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSerif",
                                color: Apptheme.mosttxtcolor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "${item['price'] * item['orderAmount']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSerif",
                                color: Apptheme.mosttxtcolor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              item['status'] ?? "Pending",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Payment",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSerif",
                                color: Apptheme.mosttxtcolor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                handlePayment(
                                  item['id'],
                                  item,
                                  double.parse(
                                    (item['price'] * item['orderAmount'])
                                        .toString(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Apptheme.buttonbglogin,
                                ),
                                foregroundColor: WidgetStateProperty.all(
                                  Apptheme.buttontxt,
                                ),
                              ),
                              child: Text(
                                item['payment'] ?? "Pay",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
