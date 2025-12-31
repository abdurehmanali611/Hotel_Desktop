// ignore_for_file: non_constant_identifier_names

import 'dart:math';
import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:hotcol/utils/responsive.dart';

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

    return LayoutBuilder(builder: (context, constraints) {
      final outerPad = Responsive.horizontalPadding(context, desktop: 24, tablet: 20, mobile: 12, verticalDesktop: 20, verticalMobile: 12);
      final isNarrow = constraints.maxWidth < 700;
      final itemHorz = min(130.0, constraints.maxWidth * 0.06);
      final cardPadding = EdgeInsets.symmetric(vertical: 20, horizontal: isNarrow ? 16 : itemHorz);

      return Container(
        padding: outerPad,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: max(16, constraints.maxWidth * 0.03)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: handleChange,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: "Handle Order",
                  ),
                  const SizedBox(width: 8),
                  const Text(
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
                    padding: cardPadding,
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
                      child: isNarrow
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _labelValue("Table No", "${item['tableNo']}"),
                                const SizedBox(height: 12),
                                _labelValue("Waiter Name", item['waiterName'] ?? ""),
                                const SizedBox(height: 12),
                                _labelValue("Item Name", "${item['title']}"),
                                const SizedBox(height: 12),
                                _labelValue("Total Price", "${item['price'] * item['orderAmount']}"),
                                const SizedBox(height: 12),
                                _labelValue("Status", item['status'] ?? "Pending"),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: item['status'] != "Completed"
                                        ? null
                                        : () {
                                            handlePayment(
                                              item['id'],
                                              item,
                                              double.parse(
                                                (item['price'] * item['orderAmount']).toString(),
                                              ),
                                            );
                                          },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                        Apptheme.buttonbglogin,
                                      ),
                                      foregroundColor: MaterialStateProperty.all(
                                        Apptheme.buttontxt,
                                      ),
                                    ),
                                    child: Text(
                                      item['payment'] ?? "Pay",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Table No",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "NotoSerif",
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
                                    const Text(
                                      "Waiter Name",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "NotoSerif",
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
                                    const Text(
                                      "Item Name",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "NotoSerif",
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
                                    const Text(
                                      "Total Price",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "NotoSerif",
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
                                    const Text(
                                      "Status",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "NotoSerif",
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
                                    const Text(
                                      "Payment",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "NotoSerif",
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: item['status'] != "Completed"
                                          ? null
                                          : () {
                                              handlePayment(
                                                item['id'],
                                                item,
                                                double.parse(
                                                  (item['price'] * item['orderAmount']).toString(),
                                                ),
                                              );
                                            },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          Apptheme.buttonbglogin,
                                        ),
                                        foregroundColor: MaterialStateProperty.all(
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
    });
  }

  Widget _labelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}