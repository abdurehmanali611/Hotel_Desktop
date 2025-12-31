// ignore_for_file: non_constant_identifier_names, unnecessary_to_list_in_spreads

import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:hotcol/utils/responsive.dart';

class UpdateDeleteIntro extends StatelessWidget {
  final void Function(dynamic) delete;
  final void Function(dynamic) update;
  final List<dynamic> items;
  final String HotelName;

  const UpdateDeleteIntro({
    super.key,
    required this.delete,
    required this.update,
    required this.items,
    required this.HotelName
  });

  @override
  Widget build(BuildContext context) {
    // Safely filter items by checking for the 'category' key
    final foodItems = items
        .where(
          (item) =>
              item is Map<String, dynamic> &&
              item.containsKey('category') &&
              item['category'].toString().toLowerCase() == "food" &&
              item['HotelName'] == HotelName,
        )
        .toList();

    final drinkItems = items
        .where(
          (item) =>
              item is Map<String, dynamic> &&
              item.containsKey('category') &&
              item['category'].toString().toLowerCase() == "drink" &&
              item['HotelName'] == HotelName,
        )
        .toList();

    return LayoutBuilder(builder: (context, constraints) {
      final padding = Responsive.horizontalPadding(context, desktop: 30, tablet: 24, mobile: 16, verticalDesktop: 50, verticalMobile: 20);

      if (constraints.maxWidth < 900) {
        return SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...foodItems.map((item) => _buildItemCard(context, item)).toList(),
              const SizedBox(height: 24),
              ...drinkItems.map((item) => _buildItemCard(context, item)).toList(),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: foodItems.map((item) => _buildItemCard(context, item)).toList(),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: drinkItems.map((item) => _buildItemCard(context, item)).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildItemCard(BuildContext context, dynamic item) {
    if (item is! Map<String, dynamic> ||
        !item.containsKey('name') ||
        !item.containsKey('imageUrl')) {
      return const SizedBox.shrink();
    }

    final String name = item['name'] ?? 'N/A';
    final String imageUrl = item['imageUrl'] ?? '';

    final horizontalMargin = Responsive.isDesktop(context) ? 100.0 : 16.0;
    final imageSize = Responsive.imageSizeFor(context, max: 230);
    final imageHeight = imageSize * 0.68;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 20),
      color: Apptheme.mostbgcolor,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "NotoSerif",
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              width: imageSize,
              height: imageHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Apptheme.mostbgcolor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Apptheme.updatebg,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey.withOpacity(0.7),
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "No Image",
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              color: Colors.grey.withOpacity(0.7),
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "No Image",
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (BuildContext dialogContex) {
                    return ElevatedButton(
                      onPressed:() => {
                        showDialog(
                          context: dialogContex,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text(
                                "Are you sure You want to Delete ${item['name']}",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    delete(item);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        ),
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Apptheme.deletebg,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          Apptheme.buttontxt,
                        ),
                      ),
                      child: Text("Delete",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => update(item),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Apptheme.updatebg),
                    foregroundColor: WidgetStateProperty.all(
                      Apptheme.buttontxt,
                    ),
                  ),
                  child: Text("Update", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}