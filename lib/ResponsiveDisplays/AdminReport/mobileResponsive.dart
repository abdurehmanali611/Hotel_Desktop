// ignore_for_file: file_names, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:hotcol/utils/apptheme.dart';
import 'package:hotcol/utils/responsive.dart';

class Mobileresponsive extends StatelessWidget {
  final List<Map<String, dynamic>> foodItems;
  final List<Map<String, dynamic>> drinkItems;
  final List<dynamic> filteredItems;
  final Widget Function(dynamic item, List<dynamic> allItems) buildItemCard;

  const Mobileresponsive({
    super.key,
    required this.foodItems,
    required this.drinkItems,
    required this.buildItemCard,
    required this.filteredItems
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemsList(context, "Food Items", foodItems),
              const SizedBox(height: 30),
              _buildItemsList(context, "Drink Items", drinkItems)
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildItemsList(context, "Food Items", foodItems)),
              const SizedBox(width: 20),
              Expanded(child: _buildItemsList(context, "Drink Items", drinkItems))
            ],
          );
        }
      },
    );
  }

  Widget _buildItemsList(BuildContext context, String title, List<Map<String, dynamic>> items) {
    final padding = Responsive.horizontalPadding(context, desktop: 24, tablet: 24, mobile: 16, verticalDesktop: 0, verticalMobile: 0);
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Apptheme.mosttxtcolor
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => buildItemCard(item, filteredItems)).toList()
        ],
      ),
    );
  }
}