// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:math';
import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:hotcol/utils/responsive.dart';

class Order extends StatelessWidget {
  final VoidCallback handleChange;
  final List<dynamic> items;
  final Function(dynamic)? onItemSelected;
  final String HotelName;

  const Order({
    super.key,
    required this.handleChange,
    required this.items,
    required this.onItemSelected,
    required this.HotelName,
  });

  @override
  Widget build(BuildContext context) {
    final foodItems = items
        .where(
          (item) =>
              item['category'].toString().toLowerCase() == "food" &&
              item['HotelName'] == HotelName,
        )
        .toList();
    final drinkItems = items
        .where(
          (item) =>
              item['category'].toString().toLowerCase() == "drink" &&
              item['HotelName'] == HotelName,
        )
        .toList();

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = min(800.0, constraints.maxWidth);
      final outerPadding = Responsive.horizontalPadding(context, desktop: 40, tablet: 24, mobile: 16, verticalDesktop: 50, verticalMobile: 24);
      final imageSize = Responsive.imageSizeFor(context, max: 260);

      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            padding: outerPadding,
            decoration: BoxDecoration(
              color: Apptheme.loginscaffold,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: max(16, maxWidth * 0.07)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Go to Payment",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        IconButton(
                          onPressed: handleChange,
                          icon: const Icon(Icons.arrow_forward),
                          tooltip: "Handle Payment",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  LayoutBuilder(builder: (context, inner) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Foods",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: foodItems.map((item) {
                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => onItemSelected?.call(item),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Tooltip(
                                            message: item['name'],
                                            child: Image.network(
                                              item['imageUrl'],
                                              width: imageSize,
                                              height: imageSize * 0.69,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                width: imageSize,
                                                height: imageSize * 0.69,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: max(16, imageSize * 0.25),
                                                  vertical: max(16, imageSize * 0.25),
                                                ),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 10,
                                                      blurRadius: 5,
                                                      offset: const Offset(0.5, 0.5),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "${item['name']}",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "NotoSerif",
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Drinks",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: drinkItems.map((item) {
                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => onItemSelected?.call(item),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Tooltip(
                                            message: item['name'],
                                            child: Image.network(
                                              item['imageUrl'] ?? "",
                                              width: imageSize,
                                              height: imageSize * 0.69,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                width: imageSize,
                                                height: imageSize * 0.69,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: max(16, imageSize * 0.25),
                                                  vertical: max(16, imageSize * 0.25),
                                                ),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 10,
                                                      blurRadius: 5,
                                                      offset: const Offset(0.5, 0.5),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "${item['name']}",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "NotoSerif",
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}