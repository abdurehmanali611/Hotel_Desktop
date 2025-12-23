// ignore_for_file: non_constant_identifier_names

import 'package:hotcol/ResponsiveDisplays/AdminReport/mobileResponsive.dart';
import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Reports extends StatelessWidget {
  final DateTime calenderResult;
  final VoidCallback handleCalender;
  final String revenuePrefix;
  final String dateStyle;
  final List<dynamic> orderItems;
  final String HotelName;
  final VoidCallback handleReportExcel;
  const Reports({
    super.key,
    required this.handleCalender,
    required this.calenderResult,
    required this.revenuePrefix,
    required this.dateStyle,
    required this.orderItems,
    required this.HotelName,
    required this.handleReportExcel,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredItems = orderItems.where((item) {
      DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(
        item['createdAt'],
      );

      bool paid = item['payment'] == "Paid";
      bool itemHotelMatch = item['HotelName'] == HotelName;

      if (revenuePrefix == "Daily") {
        return createdAt.year == calenderResult.year &&
            createdAt.month == calenderResult.month &&
            createdAt.day == calenderResult.day &&
            paid &&
            itemHotelMatch;
      } else {
        return createdAt.year == calenderResult.year &&
            createdAt.month == calenderResult.month &&
            paid &&
            itemHotelMatch;
      }
    }).toList();

    final Map<String, Map<String, dynamic>> groupedFoodItems = {};
    for (var item in filteredItems) {
      if (item['category'].toString().toLowerCase() == "food") {
        final title = item['title'].toString();
        final orderAmount = int.tryParse(item['orderAmount'].toString()) ?? 1;
        if (groupedFoodItems.containsKey(title)) {
          groupedFoodItems[title]!['orderAmount'] += orderAmount;
        } else {
          groupedFoodItems[title] = Map<String, dynamic>.from(item);
          groupedFoodItems[title]!['orderAmount'] = orderAmount;
        }
      }
    }
    final List<Map<String, dynamic>> foodItems = groupedFoodItems.values
        .toList();

    final Map<String, Map<String, dynamic>> groupedDrinkItems = {};
    for (var item in filteredItems) {
      if (item['category'].toString().toLowerCase() == "drink") {
        final title = item['title'].toString();
        final orderAmount = int.tryParse(item['orderAmount'].toString()) ?? 1;
        if (groupedDrinkItems.containsKey(title)) {
          groupedDrinkItems[title]!['orderAmount'] += orderAmount;
        } else {
          groupedDrinkItems[title] = Map<String, dynamic>.from(item);
          groupedDrinkItems[title]!['orderAmount'] = orderAmount;
        }
      }
    }

    final List<Map<String, dynamic>> drinkItems = groupedDrinkItems.values
        .toList();

    final noOrders = foodItems.isEmpty && drinkItems.isEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat(dateStyle).format(calenderResult),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Apptheme.mosttxtcolor,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Apptheme.formback.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: handleCalender,
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    color: Apptheme.buttontxt,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          noOrders
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      "There is no $revenuePrefix order Report for this ${revenuePrefix == "Daily" ? "Day" : "Month"}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Mobileresponsive(
                      foodItems: foodItems,
                      drinkItems: drinkItems,
                      filteredItems: filteredItems,
                      buildItemCard: _buildItemCard
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "$revenuePrefix Overall Sales: ${filteredItems.fold<double>(0, (sum, item) => sum + (item['price'] * (int.tryParse(item['orderAmount'].toString()) ?? 1)))} ETB",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Apptheme.mosttxtcolor,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: handleReportExcel,
                      child: Text("Export To Excel"),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildItemCard(dynamic item, List<dynamic> allItems) {
    final orderAmount = item['orderAmount'] ?? 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Apptheme.loginscaffold,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Apptheme.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item['imageUrl'],
                width: 100,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 90,
                    color: Apptheme.containerlogin,
                    child: const Icon(
                      Icons.fastfood_outlined,
                      color: Apptheme.secondaryText,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSerif',
                      color: Apptheme.mosttxtcolor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Price: ${item['price']} ETB",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Apptheme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Order Amount: $orderAmount",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Apptheme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$revenuePrefix Sales: ${double.parse((item['price'] * orderAmount).toString())} ETB",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Apptheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
