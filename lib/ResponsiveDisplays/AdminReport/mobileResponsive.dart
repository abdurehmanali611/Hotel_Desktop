// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hotcol/utils/apptheme.dart';

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
              _buildItemsList("Food Items", foodItems),
              const SizedBox(height: 30),
              _buildItemsList("Drink Items", drinkItems)
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildItemsList("Food Items", foodItems)),
              const SizedBox(width: 20),
              Expanded(child: _buildItemsList("Drink Items", drinkItems))
            ],
          );
        }
      },
    );
  }

  Widget _buildItemsList(String title, List<Map<String, dynamic>> items) {
    return Column(
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
        ...items.map((item) => buildItemCard(item, filteredItems))
      ],
    );
  }
}
